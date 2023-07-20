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
        New-GraphRequest -Method Post -Endpoint "/users/$($ContactFolder.mailBox)/contactFolders/$($ContactFolder.id)/contacts" -Body $contactBody | Out-Null
        return $true
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
}