param (
    [parameter(Mandatory)]$applicationID,
    [parameter(Mandatory)]$applicationSecret,
    [parameter(Mandatory)]$tenantID
)
BeforeAll {
    Import-Module (Resolve-Path('Module/GAL-Sync.psd1')) -Force -Verbose
}

Describe "gal-sync-graph" {
    It "Should Connect" {
        $credObject = New-Object System.Management.Automation.PSCredential ($applicationID, ($applicationSecret | ConvertTo-SecureString -AsPlainText -Force))
        Connect-GALSync -Credential $credObject -Tenant $tenantID | Should -BeTrue
    }
    It "Should return more than 1 GAL contacts" {
        (Get-GALContacts).Count | Should -BeGreaterThan 1
    }
    It "Should return 17 members" {
        Get-GALAADGroupMembers -Name "U.S. Sales" | Should -HaveCount 17 
    }
    It "Should return Contacts folder of user" {
        Get-ContactFolder -Mailbox "DiegoS@48vyq4.onmicrosoft.com" -ContactFolderName "Contacts" | Select-Object -ExpandProperty displayName | Should -Be "Contacts"
    }
    It "Should create a Contact in the folder" {
        $contactFolder = Get-ContactFolder -Mailbox "DiegoS@48vyq4.onmicrosoft.com" -ContactFolderName "Contacts"
        $contact = (Get-GALContacts)[0]
        New-FolderContact -ContactFolder $contactFolder -Contact $contact | Should -BeTrue
    }
    It "Should get the newly created contact" {
        $contactFolder = Get-ContactFolder -Mailbox "DiegoS@48vyq4.onmicrosoft.com" -ContactFolderName "Contacts"
        $contactDisplayname = ((Get-GALContacts)[0]).displayName
        Get-FolderContact -ContactFolder $contactFolder -DisplayName $contactDisplayname | Select-Object -ExpandProperty displayName | Should -Contain $contactDisplayname
    }
    It "Should be able to delete contacts" {
        $contactFolder = Get-ContactFolder -Mailbox "DiegoS@48vyq4.onmicrosoft.com" -ContactFolderName "Contacts"
        $contactDisplayname = ((Get-GALContacts)[0]).displayName
        $contact = Get-FolderContact -ContactFolder $contactFolder -DisplayName $contactDisplayname
        Remove-FolderContact -ContactFolder $contactFolder -Contact $contact | Should -BeTrue
    }
}