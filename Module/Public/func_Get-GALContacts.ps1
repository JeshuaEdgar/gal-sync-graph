function Get-GALContacts {
    [CmdletBinding()]
    param (
        [bool]$ContactsWithoutPhoneNumber,
        [bool]$ContactsWithoutEmail
    )
    try {
        Write-VerboseEvent "Getting GAL contacts"
        $allContacts = if ($UseGraphSDK) {
            Get-MgUser -All
        } else {
            New-GraphRequest -Endpoint "/users?`$select=*&`$top=999" -Beta
        }
        if (-not $ContactsWithoutPhoneNumber) {
            $allContacts = $allContacts | Where-Object { $_.businessPhones -or $_.mobilePhone }
        }
        if (-not $ContactsWithoutEmail) {
            $allContacts = $allContacts | Where-Object { $_.mail }
        }
        $returnObject = @()
        $allContacts | ForEach-Object {
            $returnObject += [pscustomobject]@{
                businessPhones = $_.businessPhones
                displayname    = $_.displayName
                givenName      = $_.givenName
                surname        = $_.surname
                jobTitle       = $_.jobTitle                
                department     = $_.department
                # homePhones     = if (-not $_.homePhones) { @() } else { @($_.homePhones) }
                emailAddresses = @(@{
                        name    = $_.mail
                        address = $_.mail
                    })
            }
        }
        Write-VerboseEvent "$($returnObject.count) contacts found"
        return $returnObject
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
}