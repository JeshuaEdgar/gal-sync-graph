function Remove-FolderContact {
    [CmdletBinding()]
    param (
        [parameter(Mandatory)][object]$ContactFolder,
        [parameter(Mandatory, ValueFromPipeline)][object]$Contact
    )
    process {
        foreach ($contactItem in $Contact) {
            try {
                if ($UseGraphSDK) {
                    Remove-MgUserContactFolderContact -UserId $ContactFolder.mailBox -ContactFolderId $ContactFolder.id -ContactId $contactItem.id
                } else {
                    New-GraphRequest -Method Delete -Endpoint "/users/$($ContactFolder.mailBox)/contactFolders/$($ContactFolder.id)/contacts/$($contactItem.id)" | Out-Null
                }
                Write-VerboseEvent "Deleted contact $($contactItem.displayName)"
                return $true
            }
            catch {
                throw (Format-ErrorCode $_).ErrorMessage
            }
        }
    }
}