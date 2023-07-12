BeforeAll {
    $moduleRoot = (Get-Item $PSScriptRoot).Parent.FullName
    $devSettings = Get-Content "$moduleRoot\Module\Tools\settings.local.json" | ConvertFrom-Json
    $validKeys = @("applicationID", "applicationSecret", "tenant")
    ForEach ($key in $devSettings.PSObject.Properties.Name) {
        if ($validKeys -Contains $key) {
            [Environment]::SetEnvironmentVariable($key, $devSettings.$key)
        }
    }
    Import-Module "$moduleRoot\Module\Gal-Sync.psd1" -Force
}

Describe "gal-sync-graph" {
    It "Should Connect" {
        $credObject = New-Object System.Management.Automation.PSCredential ($env:applicationID, ($env:applicationSecret | ConvertTo-SecureString -AsPlainText -Force))
        Connect-GALSync -Credential $credObject -Tenant $env:tenant | Should -Be $true
    }
    It "Should return more than 1 GAL contacts" {
        (Get-GALContacts).Count | Should -BeGreaterThan 1
    }
}