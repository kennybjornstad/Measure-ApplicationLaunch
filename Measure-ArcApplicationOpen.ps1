Clear-Host

[string]$CadLinkAssembly = 'C:\Program Files\Cadwell\CadLinkClientService\CadLink.Common.dll'
Add-Type -Path $CadLinkAssembly

$AppOpenTime = @()
$array = @()
$timer = 5

Write-Host 'Calculating application launch time'

do { #comment out to calculate single app open
    Start-Sleep 1 #comment out to calculate single app open
    $timer -= 1 #comment out to calculate single app open
    $ArcOpenTime = Measure-Command { #comment out to calculate single app open
        

        Start-Process -FilePath 'C:\Program Files\Cadwell\Arc\Arc.exe'
        [CadLink.Common.Authentication.UserAuthenticator]::Login('admin','admin') | Out-Null #Comment out this line to force the Arc login prompt           
        do {
            $OpenTime = Measure-Command {$windowtitle = Get-Process -Name Arc | Select-Object -ExpandProperty MainWindowTitle}
            $OpenTime | foreach {$AppOpenTime += $_}
            $TotalTimeToLoginPrompt = [math]::Round((($AppOpenTime.TotalSeconds | Measure-Object -Sum).Sum),2)
        } until ($windowtitle -eq 'Arc' -or $windowtitle -eq 'Cadwell User Login')
    

    } #comment out to calculate single app open
    Stop-Process -Name Arc #comment out to calculate single app open
    $ArcOpenTime | foreach {$array += $_} #comment out to calculate single app open
} while ($timer -gt 0) #comment out to calculate single app open

#Add a < before the pound sign to comment out this block
$arrayAvg = [math]::Round((($array.TotalSeconds | Measure-Object -Average).Average),2) #comment out to calculate single app open
#Write-Host "Average time to open Arc was $arrayAvg seconds" #comment out to calculate single app open
if ($arrayAvg -le "5" -and $windowtitle -eq 'Cadwell User Login') {
    Write-Host "Arc Login prompt took $arrayAvg seconds to appear" -ForegroundColor Green
} elseif ($arrayAvg -le "5" -and $windowtitle -eq 'Arc') { 
    Write-Host "Arc took $arrayAvg seconds to lauch" -ForegroundColor Green
} elseif ((($arrayAvg -gt "5") -and ($ArcTimeToOpen -le "10")) -and $windowtitle -eq 'Cadwell User Login') {
    Write-Host "Arc Login prompt took $arrayAvg seconds to appear" -ForegroundColor Yellow
} elseif ((($arrayAvg -gt "5") -and ($ArcTimeToOpen -le "10")) -and $windowtitle -eq 'Arc') {
    Write-Host "Arc took $arrayAvg seconds to lauch" -ForegroundColor Yellow
} elseif ($arrayAvg -gt "10" -and $windowtitle -eq 'Cadwell User Login') {
    Write-Host "Arc Login prompt took $arrayAvg seconds to appear" -ForegroundColor Red
} elseif ($arrayAvg -gt "10" -and $windowtitle -eq 'Arc') {
    Write-Host "Arc took $arrayAvg seconds to lauch" -ForegroundColor Red
}

<#
$ArcTimeToOpen = [math]::Round((($ArcOpenTime.TotalSeconds | Measure-Object -Sum).Sum),2) 
if ($ArcTimeToOpen -le "5" -and $windowtitle -eq 'Cadwell User Login') {
    Write-Host "Arc Login prompt took $ArcTimeToOpen seconds to appear" -ForegroundColor Green
} elseif ($ArcTimeToOpen -le "5" -and $windowtitle -eq 'Arc') { 
    Write-Host "Arc took $ArcTimeToOpen seconds to lauch" -ForegroundColor Green
} elseif ((($ArcTimeToOpen -gt "5") -and ($ArcTimeToOpen -le "10")) -and $windowtitle -eq 'Cadwell User Login') {
    Write-Host "Arc Login prompt took $ArcTimeToOpen seconds to appear" -ForegroundColor Yellow
} elseif ((($ArcTimeToOpen -gt "5") -and ($ArcTimeToOpen -le "10")) -and $windowtitle -eq 'Arc') {
    Write-Host "Arc took $ArcTimeToOpen seconds to lauch" -ForegroundColor Yellow
} elseif ($ArcTimeToOpen -gt "10" -and $windowtitle -eq 'Cadwell User Login') {
    Write-Host "Arc Login prompt took $ArcTimeToOpen seconds to appear" -ForegroundColor Red
} elseif ($ArcTimeToOpen -gt "10" -and $windowtitle -eq 'Arc') {
    Write-Host "Arc took $ArcTimeToOpen seconds to lauch" -ForegroundColor Red
}
#>

[CadLink.Common.Authentication.UserAuthenticator]::Logout() | Out-Null
