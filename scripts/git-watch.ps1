# Git Watch — commit + push auto sur détection de changements
# Usage: powershell -File git-watch.ps1 (s'exécute en arrière-plan)

. "$PSScriptRoot\_config.ps1"
$logFile = "$root\scripts\git-watch.log"
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $root
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true
$changed = @{}

$action = {
    $path = $Event.SourceEventArgs.FullPath
    $changeType = $Event.SourceEventArgs.ChangeType
    $ext = [System.IO.Path]::GetExtension($path)
    if ($ext -in ".git", ".log", ".last-*", ".session-*", ".known-*") { return }
    $changed[$path] = (Get-Date)
}

Register-ObjectEvent $watcher "Changed" -Action $action | Out-Null
Register-ObjectEvent $watcher "Created" -Action $action | Out-Null
Register-ObjectEvent $watcher "Deleted" -Action $action | Out-Null

Write-Host "[GIT-WATCH] Surveillance de $root"

while ($true) {
    Start-Sleep 30
    $now = Get-Date
    $pending = @($changed.GetEnumerator() | Where-Object { ($now - $_.Value).TotalSeconds -gt 25 })
    if ($pending.Count -gt 0) {
        $changed.Clear()
        $count = (git -C $root status --porcelain).Count
        if ($count -gt 0) {
            git -C $root add -A
            git -C $root commit -m "Auto-sync: $count fichiers modifiés" --quiet
            if ($env:DOTFILES_GH_TOKEN) {
                $cred = "protocol=https`nhost=github.com`nusername=andrianinairinah-code`npassword=$($env:DOTFILES_GH_TOKEN)`n"
                $cred | git -C $root credential reject | Out-Null
                $cred | git -C $root credential approve | Out-Null
                git -C $root push origin main --quiet 2>&1 | Out-Null
            }
            "$(Get-Date -Format 'yyyy-MM-dd HH:mm') | Auto-commit: $count fichiers" | Add-Content $logFile
        }
    }
}
