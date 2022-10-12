Clear-Host
$AppOpenTime = @()
Start-Process -FilePath 'C:\Cadwell\Sierra Summit\Sierra.exe'
Write-Host 'Calculating time from app launch to user login prompt'

do {
    $OpenTime = Measure-Command {$App = Get-Process -Name Sierra}
    $OpenTime | foreach {$AppOpenTime += $_}
    $TotalTimeToLoginPrompt = [math]::Round((($AppOpenTime.TotalSeconds | Measure-Object -Sum).Sum),2)
} 
#until ($App.MainWindowTitle -eq "Cadwell User Login")
until ($App.MainWindowTitle -eq "Cadwell User Login" -or $App.MainWindowTitle -eq "Sierra Summit")

if ($TotalTimeToLoginPrompt -le "4") {
    Write-Host "$($App.Name): Total time until user login prompt was $TotalTimeToLoginPrompt seconds" -ForegroundColor Green
} elseif (($TotalTimeToLoginPrompt -gt "4") -and ($TotalTimeToLoginPrompt -le "6")) {
    Write-Host "$($App.Name): Total time until user login prompt was $TotalTimeToLoginPrompt seconds" -ForegroundColor Yellow
} elseif ($TotalTimeToLoginPrompt -gt "6") {
    Write-Host "$($App.Name): Total time until user login prompt was $TotalTimeToLoginPrompt seconds" -ForegroundColor Red
}
