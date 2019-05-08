$log = "$env:USERPROFILE\AppData\Roaming\Slack\logs\browser.log"
$regex = "(\d{1}\.)(\d{1}\.)(\d{1})"
$data = Get-Content $log | Select-String "App: Welcome to Slack $regex" | Select-Object -Last 1
$data -match $regex
$version = $Matches[0]

$ssb = "$env:USERPROFILE\AppData\Local\slack\app-$version\resources\app.asar.unpacked\src\static\ssb-interop.js"
$slackDir = "$env:USERPROFILE\AppData\local\slack\slack.exe"
$theme = "https://raw.github.com/bmmcclint/slack_themes/master/theme.txt"
$themeLocation = "$env:USERPROFILE\Downloads\theme.txt"
$running = Get-Process slack -ErrorAction SilentlyContinue
$hasTheme = Get-Content $ssb | Select-String "https://cdn.rawgit.com/laCour/slack-night-mode/master/css/raw/black.css"

if ($hasTheme) {
  Write-Host "Slack is already themed..."
  if (!$running) {
    Write-Host "Slack is not running, starting now..."
    Start-Process $slackDir -ErrorAction SilentlyContinue
  }
  else {
    Write-Host "Slack is already running..."
  }
  exit
}
else {
  if ($running) {
    Write-Host "Slack is running, trying to close gracefully..."
    $running.CloseMainWindow()
    if (!$running.HasExited) {
      Write-Host "Slack requires a bit more force to close..."
      $running | Stop-Process -Force -ErrorAction SilentlyContinue
    }
  }
  if (!($themeLocation.exists)) {
    Write-Host "Downloading theme file..."
    Invoke-WebRequest $theme -OutFile $themeLocation
  }
  Write-Host "Applying theme to slack..."
  Add-Content $ssb -Value (Get-Content $themeLocation)
  Write-Host "Starting themed slack..."
  Start-Process $slackDir
  if (!$running) {
    Start-Process $slackDir
  }
  exit
}

Remove-Variable log
Remove-Variable regex
Remove-Variable data
Remove-Variable ssb
Remove-Variable slackDir
Remove-Variable theme
Remove-Variable themeLocation
Remove-Variable running
Remove-Variable hasTheme