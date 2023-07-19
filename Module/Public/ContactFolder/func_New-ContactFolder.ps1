function New-ContactFolder {
    param (
        [CmdletBinding()]
        [string]$Mailbox,
        [string]$ContactFolderName
    )
    try {
        $folderParentID = Get-ContactFolder -Mailbox $Mailbox -ContactFolderName "Contacts" | Where-Object { $_.wellKnownName } | Select-Object -ExpandProperty id
        $contactFolderBody = @{
            displayName    = $ContactFolderName
            parentFolderId = $folderParentID
        }
        $contactFolder = New-GraphRequest -Method Post -Endpoint "/users/$($Mailbox)/contactFolders" -Body $contactFolderBody -Beta
        $contactFolder | Add-Member -MemberType NoteProperty -Name "mailBox" -Value $Mailbox
        Write-LogEvent -Level Info -Message "Created folder $($ContactFolderName) for $($Mailbox)"
        # because graph is graph...
        Start-Sleep (Get-Random -Minimum 5 -Maximum 15)
        return $contactFolder | Select-Object -ExcludeProperty "@odata.context"
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
}