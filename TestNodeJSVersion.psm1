Import-Module Pansies

<#
 .Synopsis
  Checks new NodeJS versions.

 .Parameter CheckLTS
  Check only LTS or all versions.

 .Example
  Test-NodeJSVersion -lts 1 # Checks only LTS

 .Example
  Test-NodeJSVersion -lts 0 # Checks all versions
#>
function Test-NodeJSVersion {
  [CmdletBinding()]
  param(
    [alias("lts")]
    [boolean]
    $CheckLTS = $True
  )
  $NodeJSVersions = Invoke-RestMethod -Uri "https://nodejs.org/dist/index.json"
  $LatestVersion = ($CheckLTS ? $NodeJSVersions.Where({ $_.lts }) : $NodeJSVersions)[0].version
  $InstalledVersion = $(node -v)

  if ($NodeJSVersions -and $LatestVersion -and $InstalledVersion) {
    if ($InstalledVersion -ne $LatestVersion) {
      Write-Host -ForegroundColor green "Time to update Nodejs!"
      Write-Host -ForegroundColor blue "Current installed$($CheckLTS ? ' LTS ' : ' ')version: $(New-Text $InstalledVersion -ForegroundColor red)"
      Write-Host -ForegroundColor blue "New$($CheckLTS ? ' LTS ' : ' ')version: $(New-Text $LatestVersion -ForegroundColor green)"
      Write-Host -ForegroundColor blue "Info: You can use Volta, NVM, NVM Windows, n, asdf, etc. to update NodeJS."
    }
    else {
      Write-Host "You use latest$($CheckLTS ? ' LTS ' : ' ')NodeJS version!" -ForegroundColor green
    }
  }
}
