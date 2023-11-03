function Get-ContactFolder {
    param (
        [CmdletBinding()]
        [parameter(Mandatory)][string]$Mailbox,
        [string]$ContactFolderName
    )
    try {
        Write-VerboseEvent "Getting folder $ContactFolderName"
        $folderList = New-GraphRequest -Method Get -Endpoint "/users/$($Mailbox)/contactFolders?`$top=999" -Beta
        if (-not $ContactFolderName) {
            Write-VerboseEvent "Default contacts folder is querried"
            $folderList = $folderList | Where-Object { $_.wellKnownName }
        }
        else { # if ContactFolderName is not filled in
            $folderList = $folderList | Where-Object { $_.displayName -eq $ContactFolderName }
        }
        if (-not $folderList) {
            Write-VerboseEvent "Not able to find the contact folder $ContactFolderName for $Mailbox"
            return $false | Out-Null
        }

        # If there are multiple contact folders present with the same name,
        # we try to delete every one of them, return false and re-create the sync 
        # folder with the name $ContactFolderName later
        if ($folderList.Count -gt 1) {
            ForEach($folderEntry in $folderList) {
                Delete-ContactFolder -Mailbox $Mailbox -ContactFolder $folderEntry
            }
            Write-VerboseEvent -Message "Sleeping a few seconds to wait for API update"
            Start-Sleep (Get-Random -Minimum 5 -Maximum 15)
            return $false | Out-Null
        }

        $folderList | Add-Member -MemberType NoteProperty -Name "mailBox" -Value $Mailbox
        return $folderList
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
}