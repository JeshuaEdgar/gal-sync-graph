param (
    [CmdletBinding()]
    [parameter(Mandatory)][System.IO.FileInfo]$CredentialPath,
    [parameter(Mandatory)][string]$Tenant,
    [parameter(Mandatory)][string]$ContactFolderName,
    [string]$AzureADGroup,
    [string[]]$MailboxList,
    [switch]$Directory,
    [string]$LogPath,
    [switch]$ContactsWithoutPhoneNumber,
    [switch]$ContactsWithoutEmail
)

if ($LogPath) {
    Start-Transcript -OutputDirectory $LogPath
}

function Decrypt-AppSecret {
    param (
        [pscredential]$Credential
    )
    # Decrypt ApplicationSecret for getting a token
    try {
        $encrypted_data = ConvertFrom-SecureString $credential.Password
        $password_securestring = ConvertTo-SecureString $encrypted_data
        return [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password_securestring))
    }
    catch {
        throw $_.Exception.Message
    }
}

$credentialObject = Import-Clixml -Path $CredentialPath
$clientSecret = Decrypt-AppSecret $credentialObject

Connect-MgGraph -TenantId $Tenant -ClientSecretCredential $credentialObject

Import-Module .\Module\GAL-Sync.psm1 -Force

# Get users based on input
if ($Directory) { $mailBoxesToSync = (Get-GALContacts -ContactsWithoutPhoneNumber $true).emailaddresses | Select-Object -ExpandProperty address }
elseif ($AzureADGroup) { $mailBoxesToSync = Get-GALAADGroupMembers -GroupName $AzureADGroup | Select-Object -ExpandProperty mail }
elseif ($MailboxList -is [array]) { $mailBoxesToSync = $MailboxList }
else { Write-Error "No valid mailbox input"; Read-Host; exit 1 }


Write-VerboseEvent "Mailboxes to sync: $mailBoxesToSync"

$GALContacts = Get-GALContacts -ContactsWithoutPhoneNumber $ContactsWithoutPhoneNumber -ContactsWithoutEmail $ContactsWithoutEmail


foreach ($mailBox in $mailBoxesToSync) {
    try {
        Sync-GALContacts -Mailbox $mailBox -ContactList $GALContacts -ContactFolderName $ContactFolderName
    }
    catch {
        Write-LogEvent -Level Error -Message $_.Exception.Message
        Write-LogEvent -Level Error -Message "Failed to sync mailbox: $($mailBox)"
    }
}
if ($LogPath) {
    Stop-Transcript
}