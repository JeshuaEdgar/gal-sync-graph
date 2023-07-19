function Remove-FolderContact {
    param (
        [parameter(Mandatory)][object]$ContactFolder,
        [parameter(Mandatory, ValueFromPipeline)][object]$Contact
    )
    process {
        foreach ($contactItem in $Contact) {
            try {
                New-GraphRequest -Method Delete -Endpoint "/users/$($ContactFolder.mailBox)/contactFolders/$($ContactFolder.id)/contacts/$($contactItem.id)" | Out-Null
                Write-LogEvent -Level Info -Message "Removed contact $($contactItem.displayName) for $($ContactFolder.mailBox)"
                return $true
            }
            catch {
                throw (Format-ErrorCode $_).ErrorMessage
            }
        }
    }
}