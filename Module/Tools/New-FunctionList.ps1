function New-FunctionList {
    $funcList = @()
    Get-ChildItem ($pwd.Path + "/Public") -Recurse -Filter "func_*.ps1" | ForEach-Object {
        $funcList += ($_.BaseName -Split "_")[1]
    }
    return $funcList | Sort-Object
}