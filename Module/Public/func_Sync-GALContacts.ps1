function Sync-GALContacts {
    [cmdletbinding()]
    param (
        [parameter(Mandatory)][string]$Mailbox,
        [parameter(Mandatory)][string]$ContactFolderName,
        [parameter(Mandatory)][array]$ContactList
    )
    Write-LogEvent -Level Info -Message "Beginning sync of $Mailbox" 
    # Get contact folder
    try {
        $contactFolder = Get-ContactFolder -Mailbox $Mailbox -ContactFolderName $ContactFolderName
    }
    catch {
        throw "Something went wrong getting the contact folder"
    }

    # create folder
    if (-not $contactFolder) {
        try {
            $contactFolder = New-ContactFolder -Mailbox $Mailbox -ContactFolderName $ContactFolderName 
        }
        catch {
            Write-EventLog -Level Error -Message "Failed to create contact folder $ContactFolderName in mailbox $Mailbox"
        }
    }

    # get contacts in that folder
    try {
        $contactsInFolder = Get-FolderContact -ContactFolder $contactFolder 
    }
    catch {
        Write-EventLog -Level Error -Message "Failed to create contact folder $ContactFolderName in mailbox $Mailbox"
    }

    # compare lists of new contacts vs old.
    if (-not $contactsInFolder) {
        $newContacts = $ContactList
    }
    else {
        $newContacts = $ContactList | Where-Object { $_.displayName -notin $contactsInFolder.displayName }
        $comparisson = Compare-Object -ReferenceObject ($contactsInFolder | Select-Object -ExcludeProperty id) -DifferenceObject ($ContactList | Where-Object { $_.displayName -in $contactsInFolder.displayName }) 
        $removeContacts = $comparisson | Where-Object { $_.SideIndicator -eq "<=" }
        $updateContacts = $comparisson | Where-Object { $_.SideIndicator -eq "=>" }
    }

    # determine which contacts to update/remove/add
    if ($removeContacts) {
        $removeContacts | ForEach-Object { 
            try { 
                Remove-FolderContact -Contact $_ -ContactFolder $contactFolder | Out-Null
            }
            catch {
                Write-EventLog -Level Error -Message "Failed to remove contact $($_.displayName)"
            }
        }
    }

    if ($updateContacts) {
        $updateContacts | ForEach-Object { 
            try { 
                Update-FolderContact -Contact $_ -ContactFolder $contactFolder | Out-Null
            }
            catch {
                Write-EventLog -Level Error -Message "Failed to update contact $($_.displayName)"
            }
        }
    }

    if ($newContacts) {
        $newContacts | ForEach-Object { 
            try { 
                New-FolderContact -Contact $_ -ContactFolder $contactFolder | Out-Null
            }
            catch {
                Write-EventLog -Level Error -Message "Failed to create contact $($_.displayName)"
            }
        }
    }
}