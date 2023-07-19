param (
    [parameter(Mandatory)]$applicationID,
    [parameter(Mandatory)]$applicationSecret,
    [parameter(Mandatory)]$tenantID
)
BeforeAll {
    Import-Module (Resolve-Path('Module/GAL-Sync.psd1')) -Force 
    $env:mailBox = "LeeG@48vyq4.onmicrosoft.com"
    $env:contactFolderName = -join ((97..122) | Get-Random -Count 16 | ForEach-Object { [char]$_ })
    $env:randomInt = Get-Random -Maximum 17
    $env:randomUpdInt = Get-Random -Maximum 17
}

Describe "gal-sync-graph" {
    Context "Connectivity" {
        It "Should Connect" {
            $credObject = New-Object System.Management.Automation.PSCredential ($applicationID, ($applicationSecret | ConvertTo-SecureString -AsPlainText -Force))
            Connect-GALSync -Credential $credObject -Tenant $tenantID | Should -BeTrue
        }
    }
    Context "Getting contacts/users" {
        It "Should return 17 GAL contacts" {
            Get-GALContacts | Should -HaveCount 17
        }
        It "Should return 17 Azure AD members" {
            Get-GALAADGroupMembers -Name "U.S. Sales" | Should -HaveCount 17 
        }
    }
    Context "Folders" {
        It "Should create a new contactfolder" {
            New-ContactFolder -Mailbox $env:mailBox -ContactFolderName $env:contactFolderName | Select-Object -ExpandProperty displayName | Should -Be $env:contactFolderName
        }
        It "Should return contacts folder" {
            Get-ContactFolder -Mailbox $env:mailBox -ContactFolderName "Contacts" | Select-Object -ExpandProperty displayName | Should -Be "Contacts"
        }
    }
    Context "Contacts" {
        It "Should create a contact in the folder" {
            $contactFolder = Get-ContactFolder -Mailbox $env:mailBox -ContactFolderName $env:contactFolderName
            $galContact = (Get-GALContacts)[$env:randomInt]
            New-FolderContact -ContactFolder $contactFolder -Contact $galContact | Should -BeTrue
        }
        It "Should get the newly created contact" {
            $contactFolder = Get-ContactFolder -Mailbox $env:mailBox -ContactFolderName $env:contactFolderName
            $galContactDisplayname = ((Get-GALContacts)[$env:randomInt]).displayName
            Get-FolderContact -ContactFolder $contactFolder -DisplayName $galContactDisplayname | Select-Object -ExpandProperty displayName | Should -Be $galContactDisplayname
        }
        It "Should update the newly created contact" {
            $contactFolder = Get-ContactFolder -Mailbox $env:mailBox -ContactFolderName $env:contactFolderName
            $newContact = (Get-GALContacts)[$env:randomUpdInt]
            $oldContact = Get-FolderContact -ContactFolder $contactFolder 
            Update-FolderContact -ContactFolder $contactFolder -OldContact $oldContact -NewContact $newContact | Should -BeTrue
        }
        It "Should delete the newly created contact" {
            $contactFolder = Get-ContactFolder -Mailbox $env:mailBox -ContactFolderName $env:contactFolderName
            $folderContact = Get-FolderContact -ContactFolder $contactFolder
            $folderContact | Remove-FolderContact -ContactFolder $contactFolder | Should -BeTrue
        }
    }
}