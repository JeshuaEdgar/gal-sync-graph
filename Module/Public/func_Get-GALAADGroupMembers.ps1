function Get-GALAADGroupMembers {
    param (
        [CmdletBinding()]
        [Parameter(Mandatory)]
        [string]$GroupName
    )
    try {
        $userList = @()
        Write-VerboseEvent "Getting AD members for group $GroupName"
        $groupList = Get-MgGroup -Filter "DisplayName eq '$($GroupName)'"
        if ($groupList) {
            do {
                foreach ($group in $groupList) {
                    $users = Get-MgGroupMember -GroupId $group.id -All
                    $userList = $users
                    #$userList += $users | Where-Object { $_."@odata.type" -eq "#microsoft.graph.user" }
                    #$groups = $users | Where-Object { $_."@odata.type" -eq "#microsoft.graph.group" }
                }
                #$groupList = $groups
            } until (
                #($users | Where-Object { $_."@odata.type" -eq "#microsoft.graph.group" }).count -eq 0
                return false
            )
            Write-VerboseEvent "Found users in $GroupName"
            return $userList
        }
        else {
            Write-Warning "No users found in $GroupName"
        }
    }
    catch {
        throw $(Format-ErrorCode $_).ErrorMessage
    }
}