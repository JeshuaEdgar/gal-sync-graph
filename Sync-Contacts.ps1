<#
TODO:
- Sync contacts (logic in the module)
#>

param (
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

# Get users based on input
if ($Directory) { $mailBoxesToSync = Get-GALContacts -ContactsWithoutPhoneNumber $true | Select-Object -ExpandProperty mail }
elseif ($AzureADGroup) { $mailBoxesToSync = Get-GALAADGroupMembers -Name $Target | Select-Object -ExpandProperty mail }
elseif ($MailboxList -is [array]) { $mailBoxesToSync = $MailboxList }
else { Write-Error "No valid mailbox input"; Read-Host }

Import-Module .\Module\GAL-Sync.psm1 -Verbose -Force

Connect-GALSync -CredentialFile $CredentialPath -Tenant $Tenant

$GALContacts = Get-GALContacts -ContactsWithoutPhoneNumber $ContactsWithoutPhoneNumber -ContactsWithoutEmail $ContactsWithoutEmail

foreach ($mailBox in $mailBoxesToSync) {
    try {
        Sync-GALContacts -Mailbox $mailBox -ContactList $GALContacts -ContactFolderName $ContactFolderName
    }
    catch {
        Write-LogEvent -Level Error -Message "Failed to sync mailbox: $($mailBox)"
    }
}