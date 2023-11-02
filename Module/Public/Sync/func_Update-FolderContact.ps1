Import-Module Microsoft.Graph.PersonalContacts

function Update-FolderContact {
    [cmdletbinding()]
    param (
        [parameter(Mandatory)][object]$ContactFolder,
        [parameter(Mandatory)][object]$OldContact,
        [parameter(Mandatory)][object]$NewContact
    )
    try {
        $updateContactBody = @{
            givenName      = $NewContact.givenName
            surname        = $NewContact.surname
            mobilePhone    = $NewContact.mobilePhone
            jobTitle       = $NewContact.jobTitle
            department     = $NewContact.department
            emailAddresses = $NewContact.emailAddresses
        }
        # add these based on pressence
        if ($NewContact.homePhones) { $updateContactBody.homePhones = $NewContact.homePhones }
        if ($NewContact.businessPhones) { $updateContactBody.businessPhones = $NewContact.businessPhones }
        Update-MgUserContactFolderContact -UserId $ContactFolder.mailBox -ContactFolderId $ContactFolder.id -ContactId $OldContact.id -BodyParameter $updateContactBody
        Write-VerboseEvent "Updated contact $($OldContact.displayName)"
        return $true
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
}