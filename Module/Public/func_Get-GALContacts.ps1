function Get-GALContacts {
    [CmdletBinding()]
    param (
        [bool]$ContactsWithoutPhoneNumber,
        [bool]$ContactsWithoutEmail,
        [string]$ContactsFilter
    )
    try {
        $properties = @("city", "businessPhones", "mobilePhone", "mail", "displayName",
                        "givenName", "surname", "jobTitle", "department", "companyName",
                        "streetAddress")
        Write-VerboseEvent "Getting GAL contacts"
        $allContacts = if ($UseGraphSDK) {
            If($ContactsFilter) {
                Get-MgUser -ConsistencyLevel eventual -Count userCount -All -Property $properties -Filter $($ContactsFilter)
            } else {
                Get-MgUser -ConsistencyLevel eventual -All -Property $properties
            }
        } else {
            If($ContactsFilter) {
                New-GraphRequest -Endpoint "/users?`$filter=$($ContactsFilter)&`$top=999" -Beta
            } else {
                New-GraphRequest -Endpoint "/users?`$select=*&`$top=999" -Beta
            }
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
                companyName    = $_.companyName
                # homePhones     = if (-not $_.homePhones) { @() } else { @($_.homePhones) }
                businessAddress = @{
                    city = $_.city
                    street = $_.streetAddress
                }
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