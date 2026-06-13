# Installer la tâche planifiée Knowledge Watch
# À exécuter en Administrateur (clic droit > Run as Administrator)

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File D:\dotfiles\scripts\knowledge-watch.ps1 -Commit"
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At "09:00"
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
$principal = New-ScheduledTaskPrincipal -UserId "PLY" -LogonType S4U -RunLevel Limited

Register-ScheduledTask -TaskName "Knowledge Watch" -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Force
Write-Host "[OK] Tâche 'Knowledge Watch' installée — tous les lundis 09:00"
