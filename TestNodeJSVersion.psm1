Import-Module Pansies

<#
 .Synopsis
  Checks new NodeJS versions.

 .Parameter CheckOnlyLTS
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
    $CheckOnlyLTS = $True
  )
  $NodeJSVersions = Invoke-RestMethod -Uri "https://nodejs.org/dist/index.json"
  $LatestVersion = ($CheckOnlyLTS ? $NodeJSVersions.Where({ $_.lts }) : $NodeJSVersions)[0].version
  $InstalledVersion = $(node -v)

  if ($NodeJSVersions -and $LatestVersion -and $InstalledVersion) {
    if ($InstalledVersion -ne $LatestVersion) {
      Write-Host -ForegroundColor green "Time to update Nodejs!"
      Write-Host -ForegroundColor blue "Current installed$($CheckOnlyLTS ? ' LTS ' : ' ')version: $(New-Text $InstalledVersion -ForegroundColor red)"
      Write-Host -ForegroundColor blue "New$($CheckOnlyLTS ? ' LTS ' : ' ')version: $(New-Text $LatestVersion -ForegroundColor green)"
      Write-Host -ForegroundColor blue "Info: You can use Volta, NVM, NVM Windows, n, asdf, etc. to update NodeJS."
    }
    else {
      Write-Host "You use latest$($CheckOnlyLTS ? ' LTS ' : ' ')NodeJS version!" -ForegroundColor green
    }
  }
}
