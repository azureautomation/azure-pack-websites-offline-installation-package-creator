[CmdletBinding()]
param(
    [Parameter(Mandatory=$false,HelpMessage="Must end with .zip")]
    [ValidateScript({
        $_.Endswith(".zip")
    })]
    [string]$FilePath = "$env:userprofile\Downloads\WindowsAzurePackWebSites.zip"
)

#Find the latest Websites.exe in the local app data

#Get the latest folder by installation date
$websitesFile = Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\Web Platform Installer\installers" | ?{$_.Name -match "websites"} | Sort-Object LastWriteTime -Descending | Select -First 1
if((Get-ChildItem -Path $websitesFolder.FullName).Length -gt 1){
    #More than one installation, find the latest
    $websitesFile = Get-ChildItem -Path $websitesFolder.FullName | Sort-Object LastWriteTime -Descending | Select -First 1
} else {
    $websitesFile = Get-ChildItem -Path $websitesFolder.FullName | Select -First 1
}
Write-Verbose "Using the `"$($websitesFile.FullName)`" file to download Azure Pack Websites"

#Build Process
$OfflineDownloadArgs = "/quiet /log `"$("$env:TEMP\AzurePackWebsitesDownload.log")`" CreateOfflineInstallationPackage OfflineInstallationPackeFile=`"$FilePath`""
Write-Verbose "Using the following arguements: $OfflineDownloadArgs"

try{
    Write-Verbose "Staring download to `"$FilePath`""
    $DownloadProc = Start-Process -FilePath $websitesFile -ArgumentList $OfflineDownloadArgs -Wait -PassThru
}
Catch{
    Write-Error $_
    Exit $DownloadProc.ExitCode
}
Write-Verbose "Process complete"


