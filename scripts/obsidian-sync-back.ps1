# Obsidian Sync-Back — surveille nouvelles notes et propose routes
# Usage: powershell -File obsidian-sync-back.ps1
param([switch]$Suggest)

$vault = "$root\Obsidian Vault"
$root = "D:\dotfiles"
$router = "$root\agents\ROUTER.md"
$knownNotes = "$root\scripts\.known-notes"

# Notes déjà connues
$known = if (Test-Path $knownNotes) { Get-Content $knownNotes } else { @() }

# Nouvelles notes depuis dernier scan
$allNotes = Get-ChildItem $vault -Recurse -Filter "*.md" | ForEach-Object { $_.FullName.Replace("$vault\", "") }
$newNotes = $allNotes | Where-Object { $_ -notin $known }

if (-not $newNotes) { Write-Host "[OBSIDIAN] Aucune nouvelle note"; return }

Write-Host "[OBSIDIAN] Nouvelles notes:"
foreach ($note in $newNotes) {
    Write-Host "  • $note"
    if ($Suggest) {
        $content = Get-Content "$vault\$note" -Raw
        # Détecter des keywords dans la note pour suggérer une route
        if ($content -match "(?i)(music|audio|MIDI|song|génération)") {
            Write-Host "    → Suggère route: music-ai-dev"
        }
        if ($content -match "(?i)(trading|forex|MT5|backtest|MQL5)") {
            Write-Host "    → Route déjà existante (AGENTS.md)"
        }
        if ($content -match "(?i)(plugin|extension|obsidian)") {
            Write-Host "    → Suggère route: obsidian-vault"
        }
    }
}

$allNotes | Set-Content $knownNotes
