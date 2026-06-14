# Obsidian Auto-Tagger — tagge les nouvelles notes selon leur contenu
param()

. "$PSScriptRoot\_config.ps1"
$vault = "$root\Obsidian Vault"
$knownFile = "$root\scripts\.known-notes"

$known = if (Test-Path $knownFile) { Get-Content $knownFile } else { @() }
$all = Get-ChildItem $vault -Recurse -Filter "*.md" | ForEach-Object { $_.FullName.Replace("$vault\", "") }
$new = $all | Where-Object { $_ -notin $known }

$tagMap = @(
    @{pattern="(?i)(guitar|accord|gamme|arpège|rythme|pattern|exercice)"; tag="music/pedagogy"}
    @{pattern="(?i)(music|midi|audio|song|acestep|midra|yao)"; tag="music/ai"}
    @{pattern="(?i)(trading|forex|mt5|backtest|mql5|smc)"; tag="trading"}
    @{pattern="(?i)(opencode|claude|mcp|agent|skill)"; tag="dev/ai"}
    @{pattern="(?i)(obsidian|vault|plugin|note)"; tag="dev/obsidian"}
    @{pattern="(?i)(railway|deploy|docker|cloud)"; tag="dev/infra"}
    @{pattern="(?i)(erreur|error|bug|fix|problème)"; tag="dev/debug"}
    @{pattern="(?i)(refactor|architecture|design|api)"; tag="dev/architecture"}
    @{pattern="(?i)(python|javascript|typescript|rust|go)"; tag="dev/code"}
)

$tagged = @()
foreach ($note in $new) {
    $content = Get-Content "$vault\$note" -Raw
    $tags = @()
    foreach ($m in $tagMap) {
        if ($content -match $m.pattern) {
            $tags += $m.tag
        }
    }
    if ($tags.Count -gt 0) {
        $tagLine = "tags: $($tags -join ' ')"
        $newContent = $content -replace '^---\s*', "---`r`n$tagLine"
        if ($newContent -eq $content) {
            $newContent = "---`r`n$tagLine`r`n---`r`n$content"
        }
        Set-Content "$vault\$note" $newContent
        $tagged += "$note → $($tags -join ', ')"
    }
}

$all | Set-Content $knownFile
if ($tagged) { Write-Host "[TAGGER] $($tagged.Count) notes taggées" }
