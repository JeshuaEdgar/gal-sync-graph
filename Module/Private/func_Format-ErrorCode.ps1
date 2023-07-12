function Format-ErrorCode {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        $ErrorObject
    )

    try {
        if ($ErrorObject -isnot [Microsoft.PowerShell.Commands.InvokeRestMethodCommand]) {
            return $ErrorObject.Exception.Message
        }
        $httpError = $ErrorObject.Exception.Response.StatusCode.value__ #http error code (universal)

        switch ($PSVersionTable.PSEdition) {
            "Desktop" {
                $ErrorObject = New-Object System.IO.StreamReader($ErrorObject.Exception.Response.GetResponseStream())
                $ErrorObject.BaseStream.Position = 0 
                $ErrorObject.DiscardBufferedData() 
                $ErrorObject = $ErrorObject.ReadToEnd()
            }
            "Core" { $ErrorObject = $ErrorObject.ErrorDetails.Message }
        }

        $errorCode = (($ErrorObject | ConvertFrom-Json).error.code)
        $errorDesc = (($ErrorObject | ConvertFrom-Json).error.message)

        $return_object = [PSCustomObject]@{
            GraphErrorCode    = $errorCode
            GraphErrorMessage = $errorDesc
            HttpErrorCode     = $httpError
            ErrorMessage      = [string]"Error $errorCode! $errorDesc"
        }
        return $return_object
    }
    catch {
        throw $_.Exception.Message
    }
}
