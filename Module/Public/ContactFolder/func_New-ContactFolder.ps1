function New-ContactFolder {
    param (
        [CmdletBinding()]
        [string]$Mailbox,
        [string]$ContactFolderName
    )
    try {
        $folderParentID = Get-ContactFolder -Mailbox $Mailbox -ContactFolderName "Contacts" | Select-Object -ExpandProperty id
        $contactFolderBody = @{
            displayName    = $ContactFolderName
            parentFolderId = $folderParentID
        }
        return New-GraphRequest -Method Post -Endpoint "/users/$($Mailbox)/contactFolders" -Body $contactFolderBody
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
}