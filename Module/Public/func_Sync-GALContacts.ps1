function Sync-GALContacts {
    [cmdletbinding()]
    param (
        [parameter(Mandatory)][string]$Mailbox,
        [parameter(Mandatory)][string]$ContactFolderName,
        [parameter(Mandatory)][array]$ContactList
    )
    Write-LogEvent -Level Info -Message "Beginning sync for $($Mailbox)" 

    # Get/create contact folder
    try {
        $contactFolder = Get-ContactFolder -Mailbox $Mailbox -ContactFolderName $ContactFolderName
        if ($contactFolder) { Write-LogEvent -Level Info -Message "Found folder $($ContactFolderName) for $($Mailbox)" }
        else {
            try {
                $contactFolder = New-ContactFolder -Mailbox $Mailbox -ContactFolderName $ContactFolderName 
                Write-LogEvent -Level Info -Message "Created folder $($ContactFolderName) for $($Mailbox)"
            }
            catch { throw "Something went wrong creating the contact folder" }
        }
        if (-not $contactFolder) { throw "No contact folder found or not able to create one" }
    }
    catch {
        throw "Something went wrong getting the contact folder for $($Mailbox)"
    }

    # get contacts in that folder
    try {
        $contactsInFolder = Get-FolderContact -ContactFolder $contactFolder
    }
    catch {
        throw "Failed to create contact folder $($ContactFolderName) in mailbox $($Mailbox)"
    }

    # compare lists of new contacts vs old.
    if (-not $contactsInFolder) {
        $newContacts = $ContactList
    }
    else {
        $newContacts = $ContactList | Where-Object { $_.displayName -notin $contactsInFolder.displayName }
        $removeContacts = $contactsInFolder | Where-Object { $_.displayName -notin $ContactList.displayName }

        function Check-Contact {
            [CmdletBinding()]
            param (
                $ContactInFolder,
                $Contact
            )
            # loop over the properties in each contact
            foreach ($property in $ContactInFolder.PSObject.Properties) {
                $name = $property.name
                $contactListValue = $contact.$name
                $folderContactValue = $property.value
                
                if ($name -ne "id") {
                    Write-Verbose "Checking $name"
                    if ($folderContactValue -is [array] -and $name -ne "businessPhones") {
                        $difference = Compare-Object $contactListValue $folderContactValue
                        if ($null -ne $difference) {
                            Write-Verbose "$name is different"
                            $returnContact = $contact
                        }
                    }
                    elseif ($contactListValue -ne $folderContactValue) {
                        Write-Verbose "$name is different"
                        $returnContact = $contact
                    }
                }
            }
            if ($null -ne $returnContact) {
                $returnContact | Add-Member -MemberType NoteProperty -Name "id" -Value $ContactInFolder.id -Force
                return $returnContact
            }
            else {
                return $null
            }
        }

        # foreach loop over the contactlist to compare to contacts in folder
        $updateContacts = @()
        foreach ($contact in $ContactList) {
            # find matching contact
            $folderContact = $contactsInFolder | Where-Object { $_.displayName -eq $contact.displayname }
            if ($folderContact) {
                $checkedContact = Check-Contact -ContactInFolder $folderContact -Contact $contact
                if ($checkedContact) { $updateContacts += $checkedContact }
            }
        }
    }

    if ($removeContacts) {
        foreach ($contact in $removeContacts) {
            try { 
                Remove-FolderContact -Contact $contact -ContactFolder $contactFolder | Out-Null
                Write-LogEvent -Level Info -Message "Removed contact $($contact.displayName)"
            }
            catch {
                Write-LogEvent -Level Error -Message "Failed to remove contact $($contact.displayName)"
            }
        }
    }

    elseif ($updateContacts) {
        foreach ($contact in $updateContacts) { 
            try { 
                Update-FolderContact -Contact $contact -ContactFolder $contactFolder | Out-Null
                Write-LogEvent -Level Info -Message "Updated contact $($contact.displayName)"
            }
            catch {
                Write-LogEvent -Level Error -Message "Failed to update contact $($updatedContact.displayName)"
            }
        }
    }

    elseif ($newContacts) {
        foreach ($contact in $newContacts) { 
            try { 
                New-FolderContact -Contact $contact -ContactFolder $contactFolder | Out-Null
                Write-LogEvent -Level Info -Message "Created contact $($contact.displayName)"
            }
            catch {
                Write-LogEvent -Level Error -Message "Failed to create contact $($contact.displayName)"
            }
        }
    }
    else {
        Write-LogEvent -Level Info -Message "No contacts available to sync"
    }
}