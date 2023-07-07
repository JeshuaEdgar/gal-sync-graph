$moduleRoot = (Get-Item $PSScriptRoot).Parent.FullName
### Read the local.settings.json file and convert to a PowerShell object.
$devSettings = Get-Content "$moduleRoot\Tools\settings.local.json" | ConvertFrom-Json
### Loop through the settings and set environment variables for each.
$validKeys = @("applicationID", "applicationSecret", "tenant")
ForEach ($key in $devSettings.PSObject.Properties.Name) {
    if ($validKeys -Contains $key) {
        [Environment]::SetEnvironmentVariable($key, $devSettings.$key)
    }
}

Import-Module "$moduleRoot\Gal-Sync.psm1" -Force -Verbose
.\New-StoredCredential.ps1 -ApplicationID $env:applicationID -ApplicationSecret $env:applicationSecret -Verbose
Connect-GALSync -CredentialFile .\Credentials\credential.cred -Tenant $env:tenant -Verbose
Remove-Item .\Credentials\credential.cred -Verbose