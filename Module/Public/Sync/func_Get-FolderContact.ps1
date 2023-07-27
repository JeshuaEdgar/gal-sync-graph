function Get-FolderContact {
    [cmdletbinding()]
    param (
        [parameter(Mandatory)][object]$ContactFolder,
        [string]$DisplayName
    )
    try {
        $contactList = New-GraphRequest -Method Get -Endpoint "/users/$($ContactFolder.mailBox)/contactfolders/$($contactFolder.id)/contacts?`$top=999"
        if (-not $contactList) {
            Write-VerboseEvent "Not able to find contacts in folder"
            return
        }
        else {
            if ($DisplayName) {
                $contactList = $contactList | Where-Object { $_.displayName -eq $DisplayName }
            }
            $contactReturnObject = @()
            $contactList | ForEach-Object {
                $contactReturnObject += [pscustomobject]@{
                    businessPhones = $_.businessPhones
                    displayname    = $_.displayName
                    givenName      = $_.givenName
                    surname        = $_.surname
                    jobTitle       = $_.jobTitle                
                    department     = $_.department
                    homePhones     = $_.homePhones
                    emailAddresses = $_.emailAddresses
                    id             = $_.id
                }
            }
            Write-VerboseEvent "Found $($contactReturnObject.count) contacts in the folder"
            return $contactReturnObject
        }
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
}