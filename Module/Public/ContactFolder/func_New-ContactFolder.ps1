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
        $contactFolder = New-GraphRequest -Method Post -Endpoint "/users/$($Mailbox)/contactFolders" -Body $contactFolderBody
        $contactFolder | Add-Member -MemberType NoteProperty -Name "mailBox" -Value $Mailbox
        return $contactFolder
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
}