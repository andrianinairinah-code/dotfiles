# Error Log Analysis — scanne les logs d'erreur courants et les logue dans Obsidian
param()

. "$PSScriptRoot\_config.ps1"
$obsidianNotes = "$root\Obsidian Vault\03 - Ressources"
$errorLogFile = "$root\scripts\.error-log.csv"
$sources = @(
    @{path="$env:APPDATA\MetaQuotes\Tester\*\Agent-*\logs"; pattern="error|Erreur|FAIL|Exception"},
    @{path="$root\scripts\*.log"; pattern="error|Erreur|FAIL|Exception"}
)

if (-not (Test-Path $errorLogFile)) {
    "date,source,line" | Set-Content $errorLogFile
}

$found = @()
foreach ($src in $sources) {
    $files = Get-ChildItem $src.path -Filter "*.log" -ErrorAction SilentlyContinue
    foreach ($f in $files) {
        $matches = Select-String -Path $f.FullName -Pattern $src.pattern -SimpleMatch -CaseSensitive $false
        foreach ($m in $matches) {
            $found += @{date=(Get-Date -Format 'yyyy-MM-dd HH:mm'); source=$f.Name; line=$m.Line.Trim()}
        }
    }
}

if ($found.Count -gt 0) {
    $today = Get-Date -Format 'yyyy-MM-dd'
    $noteFile = "$obsidianNotes\Error Log $today.md"
    $lines = @("# Error Log — $today", "", "| Heure | Source | Message |", "|------|--------|---------|")
    foreach ($f in $found) {
        "$($f.date) | $($f.source) | $($f.line)" | Add-Content $noteFile
        "$($f.date),$($f.source),$($f.line)" | Add-Content $errorLogFile
    }
    Write-Host "[ERROR-LOG] $($found.Count) erreurs → $noteFile"
} else {
    Write-Host "[ERROR-LOG] Aucune erreur détectée"
}
