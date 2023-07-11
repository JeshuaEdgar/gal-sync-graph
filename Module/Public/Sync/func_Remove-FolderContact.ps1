function Remove-FolderContact {
    param (
        [parameter(Mandatory)][object]$ContactFolder,
        [parameter(Mandatory)][string]$Mailbox,
        [parameter(Mandatory)][object]$Contact
    )
    try {
        New-GraphRequest -Method Delete -Endpoint "/users/$($Mailbox)/contactFolders/$($ContactFolder.id)/contacts/$($Contact.id)"
        Write-LogEvent -Level Info -Message "Removed contact $($Contact.mail)"
    }
    catch {
        Write-LogEvent -Level Error -Message "Failed to remove contact $($Contact.mail)"
    }
}