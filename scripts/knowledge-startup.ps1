# Knowledge Startup — check rapide au démarrage d'une session
param([switch]$Quiet)

$root = "D:\dotfiles"
$router = "$root\agents\ROUTER.md"
$lastCheck = "$root\scripts\.last-startup-check"
$sessionLog = "$root\scripts\.session-count"
$watchState = "$root\scripts\.last-watch-state"

# 1. Compteur de sessions
$sessions = if (Test-Path $sessionLog) { [int](Get-Content $sessionLog) + 1 } else { 1 }
Set-Content $sessionLog $sessions

# 2. Skills non routées
$skills = Get-ChildItem "$root\agents\skills" -Directory -Name
$routed = Select-String -Path $router -Pattern '\|' | ForEach-Object { $_ -replace '.*\|([^|]+)\|$', '$1' } | Where-Object { $_ -match '^[a-z]' }
$orphans = $skills | Where-Object { $_ -notin $routed }

# 3. Dernière veille
$daysSinceWatch = 999
if (Test-Path $watchState) {
    $lastWatch = (Get-Content $watchState | ConvertFrom-Json).date
    $daysSinceWatch = [math]::Round(((Get-Date) - [datetime]$lastWatch).TotalDays, 1)
}

# 4. Rapport si nécessaire
$issues = @()
if ($orphans) { $issues += "Skills non routées: $($orphans -join ', ')" }
if ($daysSinceWatch -gt 7) { $issues += "Veille trop ancienne: $daysSinceWatch jours" }
if ($sessions -eq 1) { $issues += "Première session" }

Set-Content $lastCheck (Get-Date)
if (-not $Quiet -and $issues) { Write-Host "[STARTUP] $($issues -join ' | ')" }
