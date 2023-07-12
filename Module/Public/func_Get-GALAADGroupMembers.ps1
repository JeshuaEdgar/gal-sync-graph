function Get-GALAADGroupMembers {
    param (
        [CmdletBinding()]
        [Parameter(Mandatory)]
        [string]$Name
    )
    try {
        $userList = @()
        $groupList = New-GraphRequest -Method Get -Endpoint ("/groups?`$filter=startswith(displayName,'{0}')" -f $Name)
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
            return $userList
        }
        else {
            Write-Host "No users found in $Name"
        }
    }
    catch {
        throw $(Format-ErrorCode $_).ErrorMessage
    }
}