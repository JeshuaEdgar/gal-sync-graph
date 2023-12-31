function New-ContactFolder {
    param (
        [CmdletBinding()]
        [string]$Mailbox,
        [string]$ContactFolderName
    )
    try {
        Write-VerboseEvent -Message "Creating new folder $ContactFolderName"
        $contactFolder = if ($UseGraphSDK) {
            $contactFolderBody = @{
                displayName    = $ContactFolderName
            }
            New-MgUserContactFolder -UserId $Mailbox -BodyParameter $contactFolderBody
        } else {
            Write-VerboseEvent "Getting parent ID"
            $folderParentID = Get-ContactFolder -Mailbox $Mailbox | Select-Object -ExpandProperty id
            Write-VerboseEvent "Parent ID: $folderParentID"
            $contactFolderBody = @{
                displayName    = $ContactFolderName
                parentFolderId = $folderParentID
            }
            New-GraphRequest -Method Post -Endpoint "/users/$($Mailbox)/contactFolders" -Body $contactFolderBody -Beta
        }
        Write-VerboseEvent -Message "Created folder"
        $contactFolder | Add-Member -MemberType NoteProperty -Name "mailBox" -Value $Mailbox
        # because graph is graph...
        Write-VerboseEvent -Message "Sleeping a few seconds and adding $Mailbox to return object"
        Start-Sleep (Get-Random -Minimum 5 -Maximum 15)
        return $contactFolder | Select-Object -ExcludeProperty "@odata.context"
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
}