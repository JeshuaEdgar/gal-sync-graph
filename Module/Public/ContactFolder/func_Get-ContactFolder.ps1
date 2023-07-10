function Get-ContactFolder {
    param (
        [CmdletBinding()]
        [parameter(Mandatory)][string]$Mailbox,
        [parameter(Mandatory)][string]$ContactFolderName
    )
    try {
        $folderList = New-GraphRequest -Method Get -Endpoint "/users/$($Mailbox)/contactFolders" -Beta
        $contactFolder = $folderList | Where-Object { $_.displayName -eq $ContactFolderName }
        if (-not $contactFolder) {
            return $false | Out-Null
        }
        else {
            return $contactFolder
        }
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
}