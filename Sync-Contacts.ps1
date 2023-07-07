<#
TODO:
- Define params
- Import module
- Get GAL contacts
- Determine whether all contacts in the directory shoud receive the GAL or a certain Azure AD (Security) Group
- Sync contacts (logic in the module)
#>

param (
    [parameter(Mandatory)]
    [System.IO.FileInfo]$CredentialPath,

    [parameter(Mandatory)]
    [string]$Tenant,

    [parameter(Mandatory)]
    [string]$ContactFolderName,

    [parameter(Mandatory)]
    [string]$Target,

    [switch]$AzureGroup,

    [string]$LogPath,

    [switch]$ContactsWithoutPhoneNumber,

    [switch]$ContactsWithoutEmail
)

if ($LogPath) {
    Start-Transcript -OutputDirectory $LogPath
}

if ($Target -eq "All" -and (-not $AzureGroup)) {
    $mailboxesToSync = Get-Users
}

Import-Module .\Module\GAL-Sync.psm1 -Verbose -Force

Connect-GALSync -CredentialFile $CredentialPath -Tenant $Tenant

$GALContacts = Get-GALContacts -ContactsWithoutPhoneNumber $ContactsWithoutPhoneNumber -ContactsWithoutEmail $ContactsWithoutEmail

foreach ($mailBox in $mailboxesToSync) {
    try {
        Sync-GALContacts -Mailbox $mailBox -ContactList $GALContacts -ContactFolderName $ContactFolderName
    }
    catch {
        $_.Exception.Message
    }
}