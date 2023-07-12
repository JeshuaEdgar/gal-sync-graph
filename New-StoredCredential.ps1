param (
    [parameter(Mandatory)]
    $ApplicationID,
    [parameter(Mandatory)]
    $ApplicationSecret
)

$workingDir = (Get-Location).path
$credDir = "Credentials"
$credFile = "credential.cred"

try {
    if (-not (Test-Path ($workingDir, $credDir -join "\"))) {
        New-Item -Path ($workingDir, $credDir -join "\") -ItemType Directory -Force
    }
    $appSecretSecureString = ConvertTo-SecureString $ApplicationSecret -AsPlainText -Force
    $credentialObject = New-Object System.Management.Automation.PSCredential ($ApplicationID, $appSecretSecureString)
    $credentialObject | Export-Clixml -Path ($workingDir, $credDir, $credFile -join "\") -Force
    Write-Verbose "Credentials are stored successfully!"
}
catch {
    $_.Exception.Message
}
