function Delete-ContactFolder {
    param (
        [CmdletBinding()]
        [parameter(Mandatory)][string]$Mailbox,
        [parameter(Mandatory)][object]$ContactFolder
    )
    try {
        Write-VerboseEvent "Deleting ContactFolder $($ContactFolder.displayName) (ID: $($ContactFolder.id))"
        if ($UseGraphSDK) {
            Remove-MgUserContactFolder -UserId $Mailbox -ContactFolderId $ContactFolder.id
        } else {
            New-GraphRequest -Method Delete -Endpoint "/users/$($Mailbox)/contactFolders/$($ContactFolder.id)"
        }
        return
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
}