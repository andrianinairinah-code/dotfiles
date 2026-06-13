# GitHub Issues Auto-Detect — cherche les issues pertinentes pour nos projets
param()

$root = "D:\dotfiles"
$logFile = "$root\scripts\github-issues.log"
$watchFile = "$root\scripts\.known-issues"

# Projets surveillés + mots-clés pertinents
$projects = @(
    @{repo="andrianinairinah-code/dotfiles"; keywords=@("agent","skill","router","knowledge")},
    @{repo="Egonex-AI/Understand-Anything"; keywords=@("bug","windows","opencode","install")},
    @{repo="XIAODUOLU/Midra"; keywords=@("bug","feature","midi","api")},
    @{repo="shibuiwilliam/YouAndOrchestra"; keywords=@("bug","cli","agent")}
)

$known = if (Test-Path $watchFile) { Get-Content $watchFile } else { @() }
$newIssues = @()

foreach ($p in $projects) {
    try {
        $headers = @{ Accept = "application/vnd.github.v3+json"; "User-Agent" = "knowledge-watch" }
        if ($env:DOTFILES_GH_TOKEN) { $headers.Authorization = "token $env:DOTFILES_GH_TOKEN" }
        $url = "https://api.github.com/repos/$($p.repo)/issues?state=open&per_page=10&sort=created&direction=desc"
        $issues = Invoke-RestMethod -Uri $url -Headers $headers -TimeoutSec 10
        foreach ($issue in $issues) {
            if ($issue.html_url -notin $known -and $issue.title -match ($p.keywords -join '|')) {
                Write-Host "[ISSUES] $($p.repo) #$($issue.number): $($issue.title)"
                Write-Host "        → $($issue.html_url)"
                $newIssues += $issue.html_url
            }
        }
        Start-Sleep 1
    } catch { Write-Host "[ISSUES] ERREUR $($p.repo): $($_.Exception.Message)" }
}

if ($newIssues.Count -gt 0) {
    $known += $newIssues
    $known | Set-Content $watchFile
    # Notification toast
    Add-Type -AssemblyName System.Runtime.WindowsRuntime -ErrorAction SilentlyContinue
    $null = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType=WindowsRuntime]
    $template = [Windows.UI.Notifications.ToastTemplateType]::ToastText02
    $xml = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent($template)
    $xml.GetElementsByTagName("text")[0].AppendChild($xml.CreateTextNode("GitHub Issues")) | Out-Null
    $xml.GetElementsByTagName("text")[1].AppendChild($xml.CreateTextNode("$($newIssues.Count) nouvelles issues pertinentes")) | Out-Null
    $toast = New-Object Windows.UI.Notifications.ToastNotification $xml
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Knowledge Watch").Show($toast)
} else { Write-Host "[ISSUES] Aucune nouvelle issue pertinente" }
