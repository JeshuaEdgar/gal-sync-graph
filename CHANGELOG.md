# [v0.0.3-beta]

## Added

- Pagination and more verbose details for ```New-GraphRequest```

## Fixed

- Azure AD Group name in sync script
- Sync script log path stop transcript

# [v0.0.2-beta]

## Fixed

- Connect-GALSync was still requiring ```Applications.Read.All```

# [v0.0.1-beta]

## Added 

- Sync GAL Contacts with either directory (all users), Azure AD group or a mailbox list
- Store credentials for unattended scheduled use
- Docs in [README](README.md)
- Create and get contact folders
- Get, create, update and remove contacts inside of folders
- Logging for debugging
- Unit tests (ran on Microsoft 365 Dev Environment)