function Remove-FolderContact {
    param (
        [parameter(Mandatory)][object]$ContactFolder,
        [parameter(Mandatory, ValueFromPipeline)][object]$Contact
    )
    process {
        foreach ($contactItem in $Contact) {
            try {
                New-GraphRequest -Method Delete -Endpoint "/users/$($ContactFolder.mailBox)/contactFolders/$($ContactFolder.id)/contacts/$($contactItem.id)" | Out-Null
                return $true
            }
            catch {
                throw (Format-ErrorCode $_).ErrorMessage
            }
        }
    }
}