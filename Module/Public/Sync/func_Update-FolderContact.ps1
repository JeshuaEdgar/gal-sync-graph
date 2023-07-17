function Update-FolderContact {
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
            businessPhones = $NewContact.businessPhones
            jobTitle       = $NewContact.jobTitle
            emailAddresses = @(@{
                    address = $NewContact.mail
                    name    = $NewContact.displayName
                }
            )
        }
        New-GraphRequest -Method Patch -Endpoint "/users/$($ContactFolder.mailBox)/contactFolders/$($ContactFolder.id)/contacts/$($OldContact.id)" -Body $updateContactBody
        Write-LogEvent -Level Error -Message "Updated contact $($NewContact.mail)"
    }
    catch {
        Write-LogEvent -Level Error -Message "Failed to update contact $($NewContact.mail)"
    }
}