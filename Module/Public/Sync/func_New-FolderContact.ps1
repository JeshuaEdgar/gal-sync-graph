function New-FolderContact {
    param (
        [parameter(Mandatory)][object]$ContactFolder,
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
        New-GraphRequest -Method Post -Endpoint "/users/$($ContactFolder.mailBox)/contactFolders/$($ContactFolder.id)/contacts" -Body $contactBody | Out-Null
        Write-LogEvent -Level Info -Message "Created contact $($Contact.displayName) for $($ContactFolder.mailBox)"
        return $true
    }
    catch {
        # Write-LogEvent -Level Error -Message "Failed to create contact $($Contact.mail) for $($ContactFolder.mailBox)"
        throw (Format-ErrorCode $_).ErrorMessage
    }
}