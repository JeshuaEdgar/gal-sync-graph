function Get-ContactFolder {
    param (
        [CmdletBinding()]
        [parameter(Mandatory)][string]$Mailbox,
        [parameter(Mandatory)][string]$ContactFolderName
    )
    $contactsFolder = "Contacts"
    try {
        Write-VerboseEvent "Getting folder $ContactFolderName"
        $folderList = New-GraphRequest -Method Get -Endpoint ("/users/$($Mailbox)/contactFolders?`$filter=displayName eq '{0}'" -f $ContactFolderName) -Beta
        if ($ContactFolderName -like $contactsFolder) {
            Write-VerboseEvent "Default contacts folder is querried"
            $folderList = $folderList | Where-Object { $_.wellKnownName }
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