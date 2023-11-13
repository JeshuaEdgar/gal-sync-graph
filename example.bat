@echo off

PowerShell.exe -ExecutionPolicy Bypass ^
-File "%CD%\Sync-Contacts.ps1" ^
-CredentialPath "%CD%\Credentials\credential.cred" ^
-Tenant "tenant.onmicrosoft.com" ^
-ContactFolderName "Global Address List" ^
-LogPath "%CD%\Logs" ^
-AzureADGroup "SG_GALSyncUsers"
pause