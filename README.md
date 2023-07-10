# GAL (Global Address List) Sync

Ever wondered who called you from your organisation on your iPhone/Android device? Microsoft makes it unnecesarily hard to sync Global Address List contacts to your phone. Yes Outlook works great... but it does not sync with your native contacts app, so pretty useless when it comes to resolving the caller ID.

## [Changelog](CHANGELOG.md)

## How to use

1. Please [register an app following Microsoft's guide](https://learn.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app#register-an-application).
For authentication client credentials are necesary, all other forms of authentication won't be necesary.

2. Assign permissions to te app, read the list of permissions below and see why they need those permissions. This solution works on the least privelege model, so nothing more than necesarry needs to be applied.

3. Download a copy of this repository, you can do so the easiest by typing ```git clone https://github.com/JeshuaEdgar/gal-sync-graph``` in a commandline if you have git-scm or a git client installed on your machine. If not, you can go to the top, click the green "Code" button and hitting "Download ZIP".

4. Use ```Mew-StoredCredential.ps1``` to store the credentials securely on your system, this will make sure the script runs unattended.

5. Check out [example.bat](example.bat), and tweak the parameters if necessary. Please check all documentation of available parameters.

6. Check commandline output/logs for potential troubleshooting, you can always shoot in a issue on GitHub.

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
- Application.Read.All
    - [Get application permissions](https://learn.microsoft.com/en-us/graph/api/application-get)
<!-- - Exchange Online
    - Please visit [this](https://learn.microsoft.com/en-us/powershell/exchange/app-only-auth-powershell-v2?view=exchange-ps#step-2-assign-api-permissions-to-the-application) article from Microsoft and apply it to your Azure AD Application -->