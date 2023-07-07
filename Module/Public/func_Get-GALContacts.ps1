function Get-GALContacts {
    # By default return only contacts that have a valid email address and a phone number (Mobile or Business)
    param (
        [CmdletBinding()]
        [switch]$ContactsWithoutPhoneNumber,
        [switch]$ContactsWithoutEmail
    )
    try {
        $allContacts = New-GraphRequest -Method Get -Endpoint "/users?`$top=999"
        if (-not $ContactsWithoutPhoneNumber) {
            $allContacts = $allContacts | Where-Object { $_.businessPhone -or $_.mobilePhone }
        }
        if (-not $ContactsWithoutEmail) {
            $allContacts = $allContacts | Where-Object { $_.mail }
        }
        return $allContacts
    }
    catch {
        $_.Exception.Message
    }
}