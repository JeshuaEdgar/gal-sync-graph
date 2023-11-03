# GAL (Global Address List) Sync using Graph | [![Pester](https://github.com/JeshuaEdgar/gal-sync-graph/actions/workflows/pester.yml/badge.svg)](https://github.com/JeshuaEdgar/gal-sync-graph/actions/workflows/pester.yml)

Ever wondered who called you from your organisation on your iPhone/Android device? Microsoft makes it unnecesarily hard to sync Global Address List contacts to your phone. Yes Outlook works great... but it does not sync with your native contacts app, so pretty useless when it comes to resolving the caller ID.

## [Changelog](CHANGELOG.md)

## How to use

1. Please [register an app following Microsoft's guide](https://learn.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app#register-an-application).
   For authentication, client credentials are necesary, all other forms of authentication won't be necesary.

2. Assign permissions to te app, read the list of permissions below and see why they need those permissions. This solution works on the least privelege model, so nothing more than necesarry needs to be applied.

3. Download a copy of this repository, you can do so the easiest by typing `git clone https://github.com/JeshuaEdgar/gal-sync-graph` in a commandline if you have git-scm or a git client installed on your machine. If not, you can go to the top, click the green "Code" button and hitting "Download ZIP".

4. Use `Mew-StoredCredential.ps1` to store the credentials securely on your system, this will make sure the script runs unattended.

5. Check out [example.bat](example.bat), and tweak the parameters if necessary. Please check all documentation of available parameters.

6. Check commandline output/logs for potential troubleshooting, you can always shoot in a issue on GitHub.

## Parameters for sync (including examples)

- Mandatory

  - `-CredentialPath "C:\Path\To\Credentials\credential.cred`
    - Use `New-StoredCrdential.ps1` to store a new credential, it will automatically createa a credential folder and a file inside of it for unattenant scripts.
  - `-Tenant "22f2c12f-22f3-4c85-bf2c-e3f6ae7fa75b"`
    - Provide tenant ID from Azure AD or use the default \*.onmicrosoft.com address from your organisation.
  - `-ContactFolderName "GAL Sync"`
    - Provide the name of the folder that will be created under the default Contacts folder.

- Optional
  - `-Directory`
    - Use this option if you want everyone in the organisation to have the GAL list synced.
  - `-AzureADGroup "SG_GALSync"`
    - Use this option if you want to target a certain Azure AD Group.
  - `-MailboxList @("mailbox1@tosync.net", "mailbox2@tosync.net", "mailbox3@tosync.net")`
    - Use this option if you want to just sync a few mailboxes.
    - `-MailboxList "mailbox1@tosync.net"` if there is only 1 mailbox you might want to test.
  - `-LogPath C:\Path\To\Logs`
    - Define this if you want logs.
  - `-ContactsWithoutPhoneNumber`
    - Use this option if you want to sync GAL contacts without phone numbers.
  - `-ContactsWithoutEmail`
    - Use this option if you want to sync GAL contacts without email address.

## Azure Application Permissions needed

- User.Read.All
  - [List users](https://learn.microsoft.com/en-us/graph/api/user-list)
- Group.Read.All
  - [List groups](https://learn.microsoft.com/en-us/graph/api/group-list)
  - [Get group info](https://learn.microsoft.com/en-us/graph/api/group-get)
- OrgContact.Read.All
  - [List GAL contacts](https://learn.microsoft.com/en-us/graph/api/orgcontact-list)
  - [Get individual contacts](https://learn.microsoft.com/en-us/graph/api/orgcontact-get)
- Contacts.ReadWrite
  - [Create contact folder](https://learn.microsoft.com/en-us/graph/api/user-post-contactfolders)
  - [Create contact](https://learn.microsoft.com/en-us/graph/api/user-post-contacts)
  - [Update contact](https://learn.microsoft.com/en-us/graph/api/contact-update)

## Credits

- [@jussihi](https://github.com/jussihi)
  - Creating some of the modules present for the sync
