# GAL (Global Address List) Sync

Ever wondered who called you from your organisation on your iPhone/Android device? Microsoft makes it unnecesarily hard to sync Global Address List contacts to your phone. Yes Outlook works great... but it does not sync with your native contacts app, so pretty useless when it comes to resolving the caller ID.

## Azure Application Permissions needed
 
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