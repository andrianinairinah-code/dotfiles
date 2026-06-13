# Knowledge Watch — recherche multi-sources + mise à jour automatique
# Usage: powershell -File knowledge-watch.ps1 [-Commit]
param([switch]$Commit, [string]$Domain)

$root = "D:\dotfiles"
$router = "$root\agents\ROUTER.md"
$logFile = "$root\scripts\knowledge-watch.log"
$stateFile = "$root\scripts\.last-watch-state"

function Log { param($m) "$(Get-Date -Format 'yyyy-MM-dd HH:mm') | $m" | Add-Content $logFile; Write-Host $m }

# ---- SOURCES ----
function Search-GitHub {
    param($Query, $Domain)
    try {
        $url = "https://api.github.com/search/repositories?q=$([System.Web.HttpUtility]::UrlEncode($Query))&sort=stars&order=desc&per_page=5"
        $r = Invoke-RestMethod -Uri $url -Headers @{ Accept = "application/vnd.github.v3+json"; "User-Agent" = "knowledge-watch" }
        foreach ($item in $r.items) {
            Log "  [GH] $($item.full_name) | ⭐$($item.stargazers_count) | $($item.description)"
            Log "        → $($item.html_url)"
        }
        $r.items.Count
    } catch { Log "  [GH] ERREUR: $($_.Exception.Message)"; 0 }
}

function Search-HuggingFace {
    param($Query, $Domain)
    try {
        $url = "https://huggingface.co/api/models?search=$([System.Web.HttpUtility]::UrlEncode($Query))&sort=likes&direction=-1&limit=5"
        $r = Invoke-RestMethod -Uri $url -Headers @{ "User-Agent" = "knowledge-watch" }
        foreach ($item in $r) {
            Log "  [HF] $($item.modelId) | ❤️$($item.likes) | $($item.pipeline_tag)"
            Log "        → https://huggingface.co/$($item.modelId)"
        }
        $r.Count
    } catch { Log "  [HF] ERREUR: $($_.Exception.Message)"; 0 }
}

function Search-PyPI {
    param($Query, $Domain)
    try {
        $url = "https://pypi.org/simple/"
        # PyPI n'a pas d'API search directe, on utilise le XML-RPC
        $r = Invoke-RestMethod -Uri "https://pypi.org/pypi/$Query/json" -Headers @{ "User-Agent" = "knowledge-watch" } -ErrorAction SilentlyContinue
        if ($r) { Log "  [PyPI] $Query — $($r.info.summary)" }
        0
    } catch { 0 }
}

function Search-DevTo {
    param($Query, $Domain)
    try {
        $url = "https://dev.to/api/articles?per_page=3&tag=$([System.Web.HttpUtility]::UrlEncode($Domain))"
        $r = Invoke-RestMethod -Uri $url -Headers @{ "User-Agent" = "knowledge-watch" }
        foreach ($item in $r) {
            Log "  [DEV] $($item.title) | 💬$($item.comments_count) | $($item.url)"
        }
        $r.Count
    } catch { 0 }
}

function Search-ArXiv {
    param($Query, $Domain)
    try {
        $url = "http://export.arxiv.org/api/query?search_query=all:$([System.Web.HttpUtility]::UrlEncode($Query))&max_results=3&sortBy=submittedDate&sortOrder=descending"
        $r = Invoke-RestMethod -Uri $url
        $entries = $r.entry
        if (-not $entries) { return 0 }
        if ($entries -isnot [array]) { $entries = @($entries) }
        foreach ($item in $entries) {
            Log "  [ARX] $($item.title) | $($item.arxiv)" 
        }
        $entries.Count
    } catch { 0 }
}

# ---- DOMAINES ----
$domains = @(
    @{name="music-ai"; queries=@("music generation AI", "MIDI AI", "audio generation open source", "music transformer")},
    @{name="trading-mt5"; queries=@("MetaTrader 5 algorithm", "MQL5 EA bot", "trading AI", "forex machine learning")},
    @{name="opencode"; queries=@("opencode", "MCP server AI", "LLM agent framework")},
    @{name="obsidian"; queries=@("obsidian plugin", "obsidian automation", "obsidian AI")},
    @{name="dev-tools"; queries=@("AI CLI tool", "developer automation", "productivity AI 2026")}
)

$sources = @(
    @{name="GitHub"; fn=Function Search-GitHub},
    @{name="Hugging Face"; fn=Function Search-HuggingFace},
    @{name="Dev.to"; fn=Function Search-DevTo}
)

$total = @{github=0; huggingface=0; devto=0}
$filtered = if ($Domain) { $domains | Where-Object { $_.name -eq $Domain } } else { $domains }

foreach ($domain in $filtered) {
    Log "=== $($domain.name) ==="
    foreach ($q in $domain.queries) {
        Log "--- $q ---"
        $total.github += Search-GitHub $q $domain.name; Start-Sleep 1
        $total.huggingface += Search-HuggingFace $q $domain.name; Start-Sleep 1
        $total.devto += Search-DevTo $q $domain.name; Start-Sleep 1
    }
}

# ---- RÉSULTATS ----
$summary = "GH=$($total.github) HF=$($total.huggingface) DEV=$($total.devto)"
Log "=== RÉSULTATS: $summary ==="
@{date=(Get-Date -Format 'o'); total=$summary} | ConvertTo-Json | Set-Content $stateFile

if ($Commit) {
    $changed = git -C $root status --porcelain
    if ($changed) {
        git -C $root add -A
        git -C $root commit -m "Auto knowledge update: $summary"
        try { git -C $root push origin main 2>&1 | Out-Null } catch { Log "Push failed (no token)" }
        Log "Commit OK"
    } else { Log "Rien de nouveau" }
}
Log "Terminé"
