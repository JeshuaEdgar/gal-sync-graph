function Connect-GALSync {
    param (
        [CmdletBinding()]
        [parameter(Mandatory)]
        [System.IO.FileInfo]$CredentialFile,

        [parameter(Mandatory)]
        [string]$Tenant
    )

    $necesaryAppRoles = @("Group.Read.All", "OrgContact.Read.All", "Contacts.ReadWrite", "Application.Read.All", "User.Read.All")

    # Throw error if file is not present
    if (-not (Test-Path $CredentialFile)) {
        throw "File does not exist! Please check if file is present or the path is filled in correctly..."
    }

    # Decrypt ApplicationSecret for getting a token
    try {
        $credential = Import-Clixml -Path $CredentialFile
        $encrypted_data = ConvertFrom-SecureString $credential.Password
        $password_securestring = ConvertTo-SecureString $encrypted_data
        $clientSecret = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password_securestring))
    }
    catch {
        throw $_.Exception.Message
    }
    
    try {
        # Make body
        $applicationId = $credential.UserName
        $requestbody = @{
            client_id     = $applicationId
            scope         = "https://graph.microsoft.com/.default"
            client_secret = $clientSecret
            grant_type    = "client_credentials"
        }
        # Get token
        $tokenRequest = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$($Tenant)/oauth2/v2.0/token" -Method POST -Body $requestbody -ContentType "application/x-www-form-urlencoded"
        
        # Check permissions
        $tokenPayload = $tokenRequest.access_token.Split(".")[1].Replace('-', '+').Replace('_', '/')
        while ($tokenPayload.Length % 4) { $tokenPayload += "=" }
        $tokenByteArray = [System.Convert]::FromBase64String($tokenPayload)
        $applicationRoles = [System.Text.Encoding]::ASCII.GetString($tokenByteArray) | ConvertFrom-Json | Select-Object -ExpandProperty roles

        $comparisson = Compare-Object $necesaryAppRoles $applicationRoles
        if (-not ($comparisson | Where-Object { $_.SideIndicator -eq "<=" })) {
            Write-Verbose "Permissions are OK!"
        }
        else {
            throw "Missing the $(($comparisson | Where-Object {$_.SideIndicator -eq "=>"}).InputObject -join ", ") role(s), please update your application and rerun the script"
        }
        
        # Set token
        $script:galSyncData.Tenant = $Tenant
        $script:galSyncData.GraphAuthHeader = @{
            Authorization  = "Bearer $($tokenRequest.access_token)"
            "Content-Type" = "application/json"
        }
        $script:galSyncData.TokenExpiration = (Get-Date).AddSeconds($tokenRequest.expires_in)
    }
    catch {
        throw (Format-ErrorCode $_).ErrorMessage
    }
    Write-Verbose "Connected!"
}