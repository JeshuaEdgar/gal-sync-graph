function Get-GALAADGroupMembers {
    param (
        [CmdletBinding()]
        [Parameter(Mandatory)]
        [string]$Name
    )
    try {
        $userList = @()
        Write-VerboseEvent "Getting AD members for $Name"
        $groupList = New-GraphRequest -Method Get -Endpoint ("/groups?`$filter=displayName eq '{0}')" -f $Name)
        if ($groupList) {
            do {
                foreach ($group in $groupList) {
                    $users = New-GraphRequest -Method Get -Endpoint "/groups/$($group.id)/members"
                    $userList += $users | Where-Object { $_."@odata.type" -eq "#microsoft.graph.user" }
                    $groups = $users | Where-Object { $_."@odata.type" -eq "#microsoft.graph.group" }
                }
                $groupList = $groups
            } until (
                ($users | Where-Object { $_."@odata.type" -eq "#microsoft.graph.group" }).count -eq 0
            )
            Write-VerboseEvent "Found users in $Name"
            return $userList
        }
        else {
            Write-Warning "No users found in $Name"
        }
    }
    catch {
        throw $(Format-ErrorCode $_).ErrorMessage
    }
}