# Knowledge Watch — recherche GitHub + mise à jour automatique
# Usage: powershell -File knowledge-watch.ps1 [-Commit]
param([switch]$Commit)

$root = "D:\dotfiles"
$router = "$root\agents\ROUTER.md"
$logFile = "$root\scripts\knowledge-watch.log"
$stateFile = "$root\scripts\.last-watch-state"

function Log { param($m) "$(Get-Date -Format 'yyyy-MM-dd HH:mm') | $m" | Add-Content $logFile; Write-Host $m }

# Domaines à surveiller
$domains = @(
    @{name="music-ai"; query="music generation AI MIDI audio open source"; keywords=@("ACE-Step","Midra","YouAndOrchestra","K.G.One","music","MIDI","DAW")},
    @{name="trading-mt5"; query="MetaTrader 5 MQL5 trading bot AI"; keywords=@("MT5","MQL5","MetaTrader","SMC","forex")},
    @{name="opencode"; query="opencode AI agent skill MCP"; keywords=@("opencode","MCP","CLAUDE.md","agent")},
    @{name="obsidian"; query="obsidian plugin AI automation"; keywords=@("Obsidian","plugin","vault")},
    @{name="dev-tools"; query="dev tool AI automation CLI 2026"; keywords=@("CLI","automation","AI","dev")}
)

$total = 0
foreach ($domain in $domains) {
    Log "Recherche: $($domain.name)..."
    try {
        $url = "https://api.github.com/search/repositories?q=$([System.Web.HttpUtility]::UrlEncode($domain.query))&sort=stars&order=desc&per_page=5"
        $result = Invoke-RestMethod -Uri $url -Headers @{ Accept = "application/vnd.github.v3+json"; "User-Agent" = "knowledge-watch" }
        foreach ($repo in $result.items) {
            $total++
            $line = "  | $($repo.full_name) | ⭐$($repo.stargazers_count) | $($repo.description) |"
            Log $line
        }
    } catch { Log "  ERREUR: $($_.Exception.Message)" }
    Start-Sleep 1  # rate limit
}

# Mise à jour du dernier état
@{date=(Get-Date -Format 'o'); totalFound=$total} | ConvertTo-Json | Set-Content $stateFile

if ($Commit) {
    $changed = git -C $root status --porcelain
    if ($changed) {
        git -C $root add -A
        git -C $root commit -m "Auto knowledge update: $total repos found"
        try { git -C $root push origin main 2>&1 | Out-Null } catch { Log "Push failed (no token)" }
        Log "Commit: $total nouveaux repos"
    } else { Log "Rien de nouveau" }
}

Log "Terminé: $total repos trouvés"
