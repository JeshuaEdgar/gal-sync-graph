function New-GraphRequest {
    param (
        [CmdletBinding()]
        [parameter (Mandatory)]
        [string]$Endpoint,

        [parameter (Mandatory)]
        [ValidateSet("Delete", "Get", "Patch", "Post", "Put")]$Method,
        
        [array]$Body,
        [switch]$Beta
    )
    if (-not $script:galSyncData.GraphAuthHeader) {
        throw "Not authenticated, please use 'Connect-GALSync' or re-run script"
    }
    $tokenLifeTime = New-TimeSpan -Start (Get-Date) -End $script:galSyncData.TokenExpiration
    if ($tokenLifeTime.TotalMinutes -le 30) {
        Write-Warning "Token will expire in $($tokenLifeTime.TotalMinutes) minutes, consider getting a new one by using 'Connect-GALSync'"
    }
    elseif ($tokenLifeTime.TotalMinutes -le 0) {
        throw "Token expired! Please reconnect using 'Connect-GALSync'..."
    }

    if ($Beta) {
        $baseURL = "https://graph.microsoft.com/{0}/" -f "beta"
    }
    else {
        $baseURL = "https://graph.microsoft.com/{0}/" -f "v1.0"
    }
    if ($Endpoint.StartsWith("/")) {
        $Endpoint = $Endpoint.Substring(1)
    }
    #create the splat first
    $reqSplat = @{
        Method  = $Method
        URI     = $baseUrl + $Endpoint
        Headers = $script:galSyncData.GraphAuthHeader
    }
    if ($Body) {
        $reqSplat.Body += $Body | ConvertTo-Json
    }

    try {
        return (Invoke-RestMethod @reqSplat).value
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
}