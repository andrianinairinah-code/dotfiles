# Knowledge Startup Check — léger, exécuté à chaque début de session
param([switch]$Quiet)

$root = "D:\dotfiles"
$router = "$root\agents\ROUTER.md"
$lastCheck = "$root\scripts\.last-startup-check"

# 1. Vérifier si ROUTER.md est cohérent (pas de doublon, pas de skill orpheline)
$skills = Get-ChildItem "$root\agents\skills" -Directory -Name
$routed = Select-String -Path $router -Pattern '\|' | ForEach-Object { $_ -replace '.*\|([^|]+)\|$', '$1' } | Where-Object { $_ -match '^[a-z]' }
$orphans = $skills | Where-Object { $_ -notin $routed }
if ($orphans) {
    Write-Host "[KNOWLEDGE] Skills non routées : $($orphans -join ', ')"
}

# 2. Dernier check il y a combien de temps ?
if (Test-Path $lastCheck) {
    $days = [math]::Round(((Get-Date) - (Get-Item $lastCheck).LastWriteTime).TotalDays, 1)
    if ($days -gt 7) {
        Write-Host "[KNOWLEDGE] Dernière veille : $days jours. Lancer 'search new tools' ?"
    }
} else { Set-Content $lastCheck (Get-Date) }

# 3. Compter les sessions
$sessions = @(Get-ChildItem "$root\agents\skills" -Recurse -Filter "SKILL.md").Count
Write-Host "[KNOWLEDGE] $sessions skills actives | Router: $(@($routed).Count) routes"
