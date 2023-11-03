# [v0.1.1-beta]

## Added

- `Delete-ContactFolder`
  - Courtesy of [@jussihi](https://github.com/jussihi) mentioned in #3 and #5, thanks!

# [v0.1.0-beta]

## Known Issues

- Accented characters are for some weird reason not returned in the API when querying them when inside of a contactFolder, please keep this in mind as this can create errors when doing a sync.

## Removed

- `homePhones` property is removed. This might be re-added in the future, for now only `mobilePhone`/`businessPhones` properties are syncable

## Fixed

- `New-GraphRequest`
  - Fixed a bug when there was `odata.nextLink` present it would not add to the output array
- `Get-ContactFolder` is now language independant
  - `wellKnownName` property seems to be filled with the default contacts folder
- `Update-FolderContact` now works properly
- `Department` property was missing from the new contacts
- `Sync-GALContacts`'s delta sync now works properly

# [v0.0.3-beta]

## Added

- Pagination and more verbose details for `New-GraphRequest`

## Fixed

- Azure AD Group name in sync script
- Sync script log path stop transcript

# [v0.0.2-beta]

## Fixed

- Connect-GALSync was still requiring `Applications.Read.All`

# [v0.0.1-beta]

## Added

- Sync GAL Contacts with either directory (all users), Azure AD group or a mailbox list
- Store credentials for unattended scheduled use
- Docs in [README](README.md)
- Create and get contact folders
- Get, create, update and remove contacts inside of folders
- Logging for debugging
- Unit tests (ran on Microsoft 365 Dev Environment)
