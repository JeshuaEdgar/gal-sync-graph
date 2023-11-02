Import-Module Microsoft.Graph.PersonalContacts

function New-ContactFolder {
    param (
        [CmdletBinding()]
        [string]$Mailbox,
        [string]$ContactFolderName
    )
    try {
        $contact_folder_params = @{
            displayName = $ContactFolderName
        }
        Write-VerboseEvent -Message "Creating new folder $ContactFolderName"
        $contactFolder = New-MgUserContactFolder -UserId $Mailbox -BodyParameter $contact_folder_params
        $contactFolder | Add-Member -MemberType NoteProperty -Name "mailBox" -Value $Mailbox
        return $contactFolder | Select-Object -ExcludeProperty "@odata.context"
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
}