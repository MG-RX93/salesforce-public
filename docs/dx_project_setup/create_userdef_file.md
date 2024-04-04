## Create User Def File

- Create a new scratch org user, rather than use the default and generated values, create a definition file as shown below.

```json
{
    "Username": "tester1@sfdx.org",
    "LastName": "Hobbs",
    "Email": "tester1@sfdx.org",
    "Alias": "tester1",
    "TimeZoneSidKey": "America/Denver",
    "LocaleSidKey": "en_US",
    "EmailEncodingKey": "UTF-8",
    "LanguageLocaleKey": "en_US",
    "profileName": "Standard Platform User",
    "permsets": ["Dreamhouse", "Cloudhouse"],
    "generatePassword": true
}
```

- Create user command using the user-def file.
```bash
sf org create user --set-alias org-admin --definition-file config/user-def.json --target-org so01 
```