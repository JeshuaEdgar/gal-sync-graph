Import-Module Microsoft.Graph.PersonalContacts

function New-FolderContact {
    [cmdletbinding()]
    param (
        [parameter(Mandatory)][object]$ContactFolder,
        [parameter(Mandatory)][object]$Contact
    )
    $contactBody = @{
        givenName      = $contact.givenName
        surname        = $contact.surname
        mobilePhone    = $contact.mobilePhone
        jobTitle       = $contact.jobTitle
        department     = $conact.department
        emailAddresses = $contact.emailAddresses
    }
    # add these based on pressence
    if ($contact.homePhones) { $contactBody.homePhones = $contact.homePhones }
    if ($contact.businessPhones) { $contactBody.businessPhones = $contact.businessPhones }

    try {
        New-MgUserContactFolderContact -UserId $ContactFolder.mailBox -ContactFolderId $ContactFolder.id -BodyParameter $contactBody
        $encodedBody = [System.Text.Encoding]::UTF8.GetBytes($contactBody)
        Write-VerboseEvent "Created contact $($Contact.displayName)"
        return $true
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
}