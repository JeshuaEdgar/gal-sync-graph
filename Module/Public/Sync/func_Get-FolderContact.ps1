function Get-FolderContact {
    param (
        [parameter(Mandatory)][object]$ContactFolder,
        [string]$DisplayName
    )
    try {
        $contactList = New-GraphRequest -Method Get -Endpoint "/users/$($ContactFolder.mailBox)/contactfolders/$($contactFolder.id)/contacts"
        if ($DisplayName) {
            $contactList = $contactList | Where-Object { $_.displayName -eq $DisplayName }
        }
        return $contactList
    }
    catch {
        # Write-LogEvent -Level Error -Message "Failed to get contact for $($ContactFolder.mailbox)" 
        throw (Format-ErrorCode $_).ErrorMessage
    }
}