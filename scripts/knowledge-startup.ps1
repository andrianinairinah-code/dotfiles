param([switch]$Quiet)

. "$PSScriptRoot\_config.ps1"
$router = "$root\agents\ROUTER.md"
$today = Get-Date -Format 'yyyy-MM-dd'
$sessionLog = "$root\Obsidian Vault\02 - Zones\Session Log $today.md"
$lastCheck = "$root\scripts\.last-startup-check"
$sessionCountFile = "$root\scripts\.session-count"
$watchState = "$root\scripts\.last-watch-state"

# ---- SESSION COUNT ----
$sessionNum = if (Test-Path $sessionCountFile) { [int](Get-Content $sessionCountFile) + 1 } else { 1 }
Set-Content $sessionCountFile $sessionNum

# ---- 1. AUTO-FIX : skills orphelines → ajout automatique dans ROUTER.md ----
$skills = Get-ChildItem "$root\agents\skills" -Directory -Name
$routerContent = Get-Content $router -Raw
$fixes = @()
foreach ($s in $skills) {
    if ($routerContent -notmatch [regex]::Escape($s)) {
        $entry = "| 1 | *$s, $s-related* | $s |"
        $routerContent = $routerContent -replace '^## Notes', "| 1 | *$s* | $s |`r`n## Notes"
        $fixes += $s
    }
}
if ($fixes) { Set-Content $router $routerContent }

# ---- 2. SESSION LOG ----
$date = Get-Date -Format 'yyyy-MM-dd HH:mm'
$skillsLoaded = @()  # sera rempli par CLAUDE.md pendant la session
$logEntry = @"
---
## Session $sessionNum — $date
- **Skills actives** : $(($skills | Measure-Object).Count)
- **Routes ROUTER** : $((Select-String -Path $router -Pattern '\| \d').Count)
- **Auto-fix** : $(if ($fixes) { "$($fixes -join ', ') ajoutés" } else { "aucun" })
- **Veille** : $(if (Test-Path $watchState) { (Get-Content $watchState | ConvertFrom-Json).total } else { "jamais" })

"@
Add-Content $sessionLog $logEntry

# ---- 3. DAILY DIGEST ----
$today = (Get-Date).Date
$digestFile = "$root\scripts\.last-digest"
$digestDate = if (Test-Path $digestFile) { Get-Date (Get-Content $digestFile) } else { $today.AddDays(-1) }

$reports = @()
if ($digestDate -lt $today) {
    $reports += "---"
    $reports += "**Daily Digest - $(Get-Date -Format 'dddd dd MMM')**"
    $reports += "- Session #$sessionNum"
    if ($fixes) { $reports += "- Auto-fix: $($fixes -join ', ')" } else { $reports += "- Aucun fix nécessaire" }
    $lastLog = Get-Content $sessionLog -Tail 3
    $reports += "- Dernière session: $(Get-Date -Format 'HH:mm')"
    Set-Content $digestFile (Get-Date -Format 'o')
    $reports -join "`n" | Add-Content $sessionLog
}

# ---- 4. OBSIDIAN NOTES : sync-back + tagger (silencieux) ----
& "$root\scripts\obsidian-sync-back.ps1" | Out-Null
& "$root\scripts\obsidian-tagger.ps1" | Out-Null

# ---- OUTPUT ----
$issues = @()
if ($fixes) { $issues += "[AUTO-FIX] Skills ajoutées: $($fixes -join ', ')" }
if (Test-Path $watchState) { 
    $last = Get-Content $watchState | ConvertFrom-Json
    $days = [math]::Round(((Get-Date) - [datetime]$last.date).TotalDays, 1)
    if ($days -gt 7) { $issues += "[VEILLE] Dernière veille: $days jours" }
}
if (-not $Quiet -and $issues) { Write-Host "STARTUP: $($issues -join ' | ')" }
