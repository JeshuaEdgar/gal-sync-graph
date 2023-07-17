function Get-FolderContact {
    param (
        [parameter(Mandatory)][object]$ContactFolder,
        [string]$DisplayName
    )
    try {
        $contactList = New-GraphRequest -Method Get -Endpoint "/users/$($ContactFolder.mailBox)/contactfolders/$($contactFolder.id)/contacts`$top=999"
        if ($DisplayName) {
            $contactList = $contactList | Where-Object { $_.displayName -eq $DisplayName }
        }
        return $contactList
    }
    catch {
        Write-LogEvent -Level Error -Message "Failed to get folder contacts for $Mailbox"
    }
}