function Sync-GALContacts {
    param (
        [parameter(Mandatory)][string]$Mailbox,
        [parameter(Mandatory)][string]$ContactFolderName,
        [parameter(Mandatory)][array]$ContactList
    )
    
    # Get contact folder

    $contactFolder = Get-ContactFolder -Mailbox $Mailbox -ContactFolderName $ContactFolderName

    # create folder
    if (-not $contactFolder) {
        try {
            $contactFolder = New-ContactFolder -ContactFolderName $ContactFolderName 
        }
        catch {
            Write-EventLog -Level Error -Message "Failed to create contact folder $ContactFolderName in mailbox $Mailbox"
            return
        }
    }

    # get contacts in that folder
    $contactsInFolder = Get-FolderContact -ContactFolder $contactFolder 

    # compare lists of new contacts vs old.
    $removeContacts
    $updateContacts 
    $newContacts

    # determine which contacts to update/remove/add
    $removeContacts | ForEach-Object { 
        try { 
            Remove-Contact -Contact $_ -ContactFolder $contactFolder
        }
        catch {
            Write-EventLog -Level Error -Message "Failed to remove contact $_"
        }
    }

    $updateContacts | ForEach-Object { 
        try { 
            Update-Contact -Contact $_ -ContactFolder $contactFolder
        }
        catch {
            Write-EventLog -Level Error -Message "Failed to update contact $_"
        }
    }

    $newContacts | ForEach-Object { 
        try { 
            New-Contact -Contact $_ -ContactFolder $contactFolder
        }
        catch {
            Write-EventLog -Level Error -Message "Failed to create contact $_"
        }
    }
}