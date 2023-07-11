function Get-FolderContact {
    param (
        [parameter(Mandatory)][object]$ContactFolder,
        [parameter(Mandatory)][string]$Mailbox
    )
    try {
        return New-GraphRequest -Method Get -Endpoint "/users/$($Mailbox)/contactfolders/$($contactFolder.id)/contacts"
    }
    catch {
        Write-LogEvent -Level Error -Message "Failed to get folder contacts for $Mailbox"
    }
}