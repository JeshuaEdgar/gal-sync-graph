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
        exit
        $newContacts = $ContactList | Where-Object { $_.displayName -notin $contactsInFolder.displayName }
        $comparisson = Compare-Object -ReferenceObject $contactsInFolder -DifferenceObject ($ContactList | Where-Object { $_.displayName -in $contactsInFolder.displayName }) 
        $removeContacts = $comparisson | Where-Object { $_.SideIndicator -eq "<=" }
        $updateContacts = $comparisson | Where-Object { $_.SideIndicator -eq "=>" }
    }

    # determine which contacts to update/remove/add
    if ($removeContacts) {
        $removeContacts.InputObject | ForEach-Object {
            try { 
                Remove-FolderContact -Contact $_ -ContactFolder $contactFolder | Out-Null
                Write-LogEvent -Level Info -Message "Removed contact $($_.displayName)"
            }
            catch {
                Write-LogEvent -Level Error -Message "Failed to remove contact $($_.displayName)"
            }
        }
    }

    elseif ($updateContacts) {
        $updateContacts | ForEach-Object { 
            try { 
                Update-FolderContact -Contact $_ -ContactFolder $contactFolder | Out-Null
                Write-LogEvent -Level Info -Message "Updated contact $($_.displayName)"
            }
            catch {
                Write-LogEvent -Level Error -Message "Failed to update contact $($_.displayName)"
            }
        }
    }

    elseif ($newContacts) {
        $newContacts | ForEach-Object { 
            try { 
                New-FolderContact -Contact $_ -ContactFolder $contactFolder | Out-Null
                Write-LogEvent -Level Info -Message "Created contact $($_.displayName)"
            }
            catch {
                Write-LogEvent -Level Error -Message "Failed to create contact $($_.displayName)"
            }
        }
    }
    else {
        Write-LogEvent -Level Info -Message "No new contacts available to sync"
    }
}