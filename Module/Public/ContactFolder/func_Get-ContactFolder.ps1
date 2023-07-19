function Get-ContactFolder {
    param (
        [CmdletBinding()]
        [parameter(Mandatory)][string]$Mailbox,
        [parameter(Mandatory)][string]$ContactFolderName
    )
    $contactsFolder = "contacts"
    try {
        $folderList = New-GraphRequest -Method Get -Endpoint ("/users/$($Mailbox)/contactFolders?`$filter=displayName eq '{0}'" -f $ContactFolderName) -Beta
        if (-not $folderList) {
            return $false | Out-Null
        }
        if ($ContactFolderName -like $contactsFolder) {
            $folderList = $folderList | Where-Object { $_.wellKnownName }
        }
        $folderList | Add-Member -MemberType NoteProperty -Name "mailBox" -Value $Mailbox
        return $folderList
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
}