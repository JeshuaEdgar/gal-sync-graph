Import-Module Microsoft.Graph.PersonalContacts

function Get-ContactFolder {
    param (
        [CmdletBinding()]
        [parameter(Mandatory)][string]$Mailbox,
        [parameter(Mandatory)][string]$ContactFolderName
    )
    $contactsFolder = "Contacts"
    try {
        Write-VerboseEvent "Getting folder $ContactFolderName"
        $folderList = Get-MgUserContactFolder -UserId $Mailbox -Filter "displayName eq '$ContactFolderName'"
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