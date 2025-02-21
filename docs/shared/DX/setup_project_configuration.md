## Setup DX Project Configuration

- Sample file
```json
{
  "packageDirectories": [
    {
      "path": "util",
      "default": true,
      "package": "Salesforce Public - Util",
      "versionNumber": "1.0.0.NEXT",
      "definitionFile": "config/scratch-org-def.json"
    }
  ],
  "name": "salesforce-public",
  "namespace": "",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "59.0"
}
```
[Salesforce Documentation](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm)