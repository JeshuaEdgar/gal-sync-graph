function Remove-FolderContact {
    param (
        [parameter(Mandatory)][object]$ContactFolder,
        [parameter(Mandatory)][object]$Contact
    )
    process {
        try {
            New-GraphRequest -Method Delete -Endpoint "/users/$($ContactFolder.mailBox)/contactFolders/$($ContactFolder.id)/contacts/$($Contact.id)"
            Write-LogEvent -Level Info -Message "Removed contact $($Contact.mail)"
            return $true
        }
        catch {
            # Write-LogEvent -Level Error -Message "Failed to remove contact $($Contact.mail)"
            throw (Format-ErrorCode $_).ErrorMessage
        }
    }
}