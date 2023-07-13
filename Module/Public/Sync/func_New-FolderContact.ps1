function New-FolderContact {
    param (
        [parameter(Mandatory)][object]$ContactFolder,
        [parameter(Mandatory)][string]$Mailbox,
        [parameter(Mandatory)][object]$Contact
    )
    $contactBody = @{
        givenName      = $contact.givenName
        surname        = $contact.surname
        mobilePhone    = $contact.mobilePhone
        businessPhones = $contact.businessPhones
        jobTitle       = $contact.jobTitle
        emailAddresses = @(@{
                address = $contact.mail
                name    = $contact.displayName
            }
        )
    }
    try {
        $newContact = New-GraphRequest -Method Post -Endpoint "/users/$($Mailbox)/contactFolders/$($ContactFolder.id)/contacts" -Body $contactBody
        Write-LogEvent -Level Info -Message "Created contact $($Contact.mail)"
        return $newContact
    }
    catch {
        Write-LogEvent -Level Error -Message "Failed to create contact $($Contact.mail) for $Mailbox"
    }
}