param (
    [parameter(Mandatory)]$applicationID,
    [parameter(Mandatory)]$applicationSecret,
    [parameter(Mandatory)]$tenantID
)
BeforeAll {
    $moduleRoot = (Get-Item $PSScriptRoot).Parent.FullName 
    Import-Module "$moduleRoot\Module\Gal-Sync.psd1" -Force
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
        (Get-GALAADGroupMembers -Name "U.S. Sales").Count | Should -Be 17
    }
    It "Should return Contacts folder of user" {
        Get-ContactFolder -Mailbox "DiegoS@48vyq4.onmicrosoft.com" -ContactFolderName "Contacts" | Select-Object -ExpandProperty displayName | Should -Be "Contacts"
    }
    # It "Should create a Contact in the folder" {
    #     $contactFolder = Get-ContactFolder -Mailbox "DiegoS@48vyq4.onmicrosoft.com" -ContactFolderName "Contacts"
    #     $contact = (Get-GALContacts)[0]
    #     New-FolderContact -ContactFolder $contactFolder -Mailbox "DiegoS@48vyq4.onmicrosoft.com" -Contact $contact
    # }
    # It "Should get the newly created contact" {
    #     $contactFolder = Get-ContactFolder -Mailbox "DiegoS@48vyq4.onmicrosoft.com" -ContactFolderName "Contacts"
    #     $contactDisplayname = ((Get-GALContacts)[0]).displayName
    #     [string](Get-FolderContact -ContactFolder $contactFolder -Mailbox "DiegoS@48vyq4.onmicrosoft.com" -DisplayName | Select-Object -ExpandProperty displayName) | Should -BeExactly $contactDisplayname
    # }
    # It "Should be able to delete the contact" {
    #     $contactFolder = Get-ContactFolder -Mailbox "DiegoS@48vyq4.onmicrosoft.com" -ContactFolderName "Contacts"
    #     $contact = Get-FolderContact -ContactFolder $contactFolder -Mailbox "DiegoS@48vyq4.onmicrosoft.com"
    #     Remove-FolderContact -ContactFolder $contactFolder -Mailbox "DiegoS@48vyq4.onmicrosoft.com" -Contact $contact
    # }
}