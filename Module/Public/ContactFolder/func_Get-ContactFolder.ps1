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
            $folderList = $folderList | Where-Object { $_.displayName -like $ContactFolderName }
        }
        if (-not $folderList) {
            Write-VerboseEvent "Not able to find the contact folder $ContactFolderName for $Mailbox"
            return $false | Out-Null
        }
        Write-VerboseEvent "Found folder $ContactFolderName, returning!"
        $folderList | Add-Member -MemberType NoteProperty -Name "mailBox" -Value $Mailbox
        return $folderList
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
}