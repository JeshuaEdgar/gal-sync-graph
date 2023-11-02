Import-Module Microsoft.Graph.PersonalContacts

function Remove-FolderContact {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)][object]$ContactFolder,
        [parameter(Mandatory, ValueFromPipeline)][object]$Contact
    )
    process {
        foreach ($contactItem in $Contact) {
            try {
                Remove-MgUserContactFolderContact -UserId $ContactFolder.mailBox -ContactFolderId $ContactFolder.id -ContactId $contactItem.id
                Write-VerboseEvent "Deleted contact $($contactItem.displayName)"
                return $true
            }
            catch {
                throw (Format-ErrorCode $_).ErrorMessage
            }
        }
    }
}