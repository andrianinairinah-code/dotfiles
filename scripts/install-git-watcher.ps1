# Installer le Git Watcher (démarre au login Windows)
# Usage: powershell -File install-git-watcher.ps1

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File D:\dotfiles\scripts\git-watch.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogOn
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName "Git Watch" -Action $action -Trigger $trigger -Settings $settings -Force
Write-Host "[OK] Git Watch installé — démarre au login"
