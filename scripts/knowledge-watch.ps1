# Knowledge Watch v2 — multi-source, rapport hebdo, notification desktop
param([switch]$Commit, [string]$Domain, [switch]$Weekly)

$root = "D:\dotfiles"
$router = "$root\agents\ROUTER.md"
$logFile = "$root\scripts\knowledge-watch.log"
$stateFile = "$root\scripts\.last-watch-state"
$reportDir = "$root\Obsidian Vault\03 - Ressources"

function Log { param($m) "$(Get-Date -Format 'yyyy-MM-dd HH:mm') | $m" | Add-Content $logFile; Write-Host $m }

# ---- NOTIFICATION DESKTOP ----
function Send-Toast {
    param($Title, $Body)
    try {
        Add-Type -AssemblyName System.Runtime.WindowsRuntime
        $null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType=WindowsRuntime]
        $template = [Windows.UI.Notifications.ToastTemplateType]::ToastText02
        $xml = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent($template)
        $xml.GetElementsByTagName("text")[0].AppendChild($xml.CreateTextNode($Title)) | Out-Null
        $xml.GetElementsByTagName("text")[1].AppendChild($xml.CreateTextNode($Body)) | Out-Null
        $toast = New-Object Windows.UI.Notifications.ToastNotification $xml
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Knowledge Watch").Show($toast)
    } catch { Log "  [TOAST] impossible (module manquant)" }
}

# ---- SOURCES ----
function Search-GitHub {
    param($Query, $Domain)
    try {
        $headers = @{ Accept = "application/vnd.github.v3+json"; "User-Agent" = "knowledge-watch" }
        if ($env:DOTFILES_GH_TOKEN) { $headers.Authorization = "token $env:DOTFILES_GH_TOKEN" }
        $url = "https://api.github.com/search/repositories?q=$([System.Web.HttpUtility]::UrlEncode($Query))&sort=stars&order=desc&per_page=5"
        $r = Invoke-RestMethod -Uri $url -Headers $headers -TimeoutSec 10
        $items = @()
        foreach ($item in $r.items) {
            Log "  [GH] $($item.full_name) | ⭐$($item.stargazers_count)"
            $items += $item
        }
        $items.Count
    } catch { Log "  [GH] ERREUR"; 0 }
}

function Search-HuggingFace {
    param($Query, $Domain)
    try {
        $url = "https://huggingface.co/api/models?search=$([System.Web.HttpUtility]::UrlEncode($Query))&sort=likes&direction=-1&limit=5"
        $r = Invoke-RestMethod -Uri $url -TimeoutSec 10
        $count = 0
        foreach ($item in $r) {
            Log "  [HF] $($item.modelId) | ❤️$($item.likes)"
            $count++
        }
        $count
    } catch { 0 }
}

function Search-DevTo {
    param($Query, $Domain)
    try {
        $url = "https://dev.to/api/articles?per_page=3&tag=$([System.Web.HttpUtility]::UrlEncode($Domain))"
        $r = Invoke-RestMethod -Uri $url -TimeoutSec 10
        $count = 0
        foreach ($item in $r) {
            Log "  [DEV] $($item.title) | 💬$($item.comments_count)"
            $count++
        }
        $count
    } catch { 0 }
}

function Search-Reddit {
    param($Query, $Domain)
    try {
        $url = "https://www.reddit.com/search/.json?q=$([System.Web.HttpUtility]::UrlEncode($Query))&sort=top&t=month&limit=5"
        $r = Invoke-RestMethod -Uri $url -Headers @{"User-Agent"="knowledge-watch/1.0"} -TimeoutSec 10
        $count = 0
        foreach ($item in $r.data.children) {
            Log "  [RED] $($item.data.subreddit) › $($item.data.title) | 👍$($item.data.score)"
            $count++
        }
        $count
    } catch { 0 }
}

function Search-ArXiv {
    param($Query, $Domain)
    try {
        $url = "http://export.arxiv.org/api/query?search_query=all:$([System.Web.HttpUtility]::UrlEncode($Query))&max_results=3&sortBy=submittedDate&sortOrder=descending"
        $r = Invoke-RestMethod -Uri $url -TimeoutSec 10
        $entries = $r.entry
        if (-not $entries) { return 0 }
        if ($entries -isnot [array]) { $entries = @($entries) }
        foreach ($item in $entries) {
            $title = ($item.title -replace '\s+', ' ').Trim()
            Log "  [ARX] $title"
        }
        $entries.Count
    } catch { 0 }
}

# ---- DOMAINES ----
$domains = @(
    @{name="music-ai"; queries=@("music generation AI", "MIDI composition AI", "audio generation open source")},
    @{name="trading-mt5"; queries=@("MetaTrader 5 MQL5", "trading bot AI", "forex algorithm")},
    @{name="opencode"; queries=@("opencode AI agent", "MCP server LLM", "agent framework")},
    @{name="obsidian"; queries=@("obsidian plugin AI", "obsidian automation workflow")},
    @{name="dev-tools"; queries=@("AI developer tools 2026", "CLI productivity automation")}
)

$sources = @(
    @{name="GitHub"; fn=Function Search-GitHub},
    @{name="Hugging Face"; fn=Function Search-HuggingFace},
    @{name="Dev.to"; fn=Function Search-DevTo},
    @{name="Reddit"; fn=Function Search-Reddit},
    @{name="ArXiv"; fn=Function Search-ArXiv}
)

$filtered = if ($Domain) { $domains | Where-Object { $_.name -eq $Domain } } else { $domains }
$reportLines = @("# Veille Technologique — $(Get-Date -Format 'yyyy-MM-dd')", "", "| Source | Domaine | Résultat |", "|--------|---------|----------|")

foreach ($domain in $filtered) {
    Log "=== $($domain.name) ==="
    foreach ($q in $domain.queries) {
        Log "--- $q ---"
        foreach ($src in $sources) {
            $count = & $src.fn $q $domain.name
            if ($count -gt 0 -or $Weekly) {
                $reportLines += "| $($src.name) | $($domain.name) | $count résultats |"
            }
            Start-Sleep 0.5
        }
    }
}

# ---- RAPPORT HEBDOMADAIRE ----
if ($Weekly) {
    $reportFile = "$reportDir\Veille $(Get-Date -Format 'yyyy-MM-dd').md"
    $reportLines += "", "---", "_Généré par Knowledge Watch v2_"
    $reportLines -join "`n" | Set-Content $reportFile -Encoding UTF8
    Log "[RAPPORT] → $reportFile"
}

# ---- NOTIFICATION ----
$summary = (Get-Content $stateFile -Raw | ConvertFrom-Json).total
if (-not $summary) { $summary = "GH=0 HF=0 DEV=0 RED=0 ARX=0" }
Log "=== RÉSULTATS: $summary ==="
@{date=(Get-Date -Format 'o'); total=$summary} | ConvertTo-Json | Set-Content $stateFile
if ($summary -match "GH=(\d+)") { $gh = $Matches[1]; if ([int]$gh -gt 3) { Send-Toast "Knowledge Watch" "$summary — nouveaux outils !" } }

# ---- GIT ----
if ($Commit) {
    $changed = git -C $root status --porcelain
    if ($changed) {
        git -C $root add -A
        git -C $root commit -m "Knowledge watch: $summary"
        if ($env:DOTFILES_GH_TOKEN) {
            $pushUrl = "https://andrianinairinah-code:$($env:DOTFILES_GH_TOKEN)@github.com/andrianinairinah-code/dotfiles.git"
            try { git -C $root push $pushUrl main 2>&1 | Out-Null; Log "Push OK" } catch { Log "Push failed" }
        }
    } else { Log "Rien de nouveau" }
}
# Post-watch: analytics + issues + tagger (silencieux)
& "$root\scripts\analytics-collect.ps1" -Report | Out-Null
& "$root\scripts\github-issues.ps1" | Out-Null
Log "Terminé"
