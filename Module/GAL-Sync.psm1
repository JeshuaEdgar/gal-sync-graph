#region discover module name
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
$ModuleName = $ExecutionContext.SessionState.Module
Write-Verbose "Loading module $ModuleName..."
#endregion discover module name

#load variables for module
Write-Verbose "Creating modules variables..."
$script:galSyncData = @{
    Tenant          = $null
    GraphAuthHeader = $null
    TokenExpiration = $null
}

#load functions
try {
    foreach ($Scope in 'Public', 'Private') {
        Get-ChildItem (Join-Path -Path $ScriptPath -ChildPath $Scope) -Recurse -Filter "func_*.ps1" | ForEach-Object {
            . $_.FullName
            if ($Scope -eq 'Public') {
                Export-ModuleMember -Function ($_.BaseName -Split "_")[1] -ErrorAction Stop
            }
        }
    }
}
catch {
    Write-Error ("{0}: {1}" -f $_.BaseName, $_.Exception.Message)
    exit 1
}