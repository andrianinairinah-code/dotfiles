# Skill Usage Analytics — track skill loads, auto-archive unused
param([switch]$Report)

. "$PSScriptRoot\_config.ps1"
$logFile = "$root\scripts\.skill-usage.csv"
$skillsDir = "$root\agents\skills"
$archiveDir = "$root\agents\_archived"

if (-not (Test-Path $logFile)) {
    "date,skill,source" | Set-Content $logFile
}

# Enregistrer une utilisation (appelé par le startup)
function Log-Usage {
    param($Skill)
    "$(Get-Date -Format 'yyyy-MM-dd'),$Skill,session" | Add-Content $logFile
}

# Analyser et archiver les skills inutilisées depuis 30+ jours
function Auto-Archive {
    $usage = Get-Content $logFile | Select-Object -Skip 1 | ConvertFrom-Csv -Delimiter ','
    $active = $usage | Where-Object { [datetime]$_.date -gt (Get-Date).AddDays(-30) } | Select-Object -ExpandProperty skill -Unique
    $allSkills = Get-ChildItem $skillsDir -Directory -Name
    $unused = $allSkills | Where-Object { $_ -notin $active }

    $archived = @()
    foreach ($s in $unused) {
        $src = Join-Path $skillsDir $s
        $dst = Join-Path $archiveDir $s
        if (Test-Path $src) {
            New-Item -ItemType Directory -Path $archiveDir -Force | Out-Null
            Move-Item $src $dst -Force
            $archived += $s
        }
    }
    if ($archived) { Write-Host "[ANALYTICS] Archivé: $($archived -join ', ')" }
}

if ($Report) {
    $usage = Get-Content $logFile | Select-Object -Skip 1 | ConvertFrom-Csv -Delimiter ','
    $summary = $usage | Group-Object skill | Sort-Object Count -Descending | Select-Object Name, Count
    Write-Host "=== SKILL USAGE (30j) ==="
    $summary | ForEach-Object { Write-Host "  $($_.Name): $($_.Count) fois" }
    if ($summary.Count -gt 0) {
        $least = $summary | Select-Object -Last 3
        Write-Host "Moins utilisées: $($least.Name -join ', ')"
    }
    Auto-Archive
}
