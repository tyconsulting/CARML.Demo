# Demo Bicep module

Deploys a standard Storage Account that aligns with the company standard.

This bicep template demonstrates how to use customized overlay modules on top of CARML modules.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
location       | No       | Optional. The geo-location where the resource lives.
tags           | No       | Optional. Tags of the resource.
privateEndpointVnetResourceGroup | Yes      | Existing Private Endpoint Vnet Resource Group
privateEndpointVnetName | Yes      | Existing Private Endpoint Vnet Name
privateEndpointSubnetName | Yes      | Existing Private Endpoint Subnet Name
keyVaultName   | Yes      | The name of the key vault
keyVaultPrivateEndpointName | Yes      | The name of the key vault private endpoint
keyVaultPrivateEndpointIP | No       | Optional. The static IP address assigned to the Private Endpoint for the Key Vault
storageAccountName | Yes      | Required. Name of the storage account.
blobContainers | No       | Optional. list of Additional blob containers to be created in the Synapse Storage Account.
storageAccountBlobPrivateEndpointName | Yes      | Name of the Blob Private Endpoint for the Storage Account
storageAccountBlobPrivateEndpointIP | No       | Optional. The static IP address assigned to the Blob Private Endpoint for the Storage Account
storageAccountDfsPrivateEndpointName | Yes      | Name of the Dfs Private Endpoint for the Storage Account
storageAccountDfsPrivateEndpointIP | No       | Optional. The static IP address assigned to the Dfs Private Endpoint for the Storage Account

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The geo-location where the resource lives.

- Default value: `[resourceGroup().location]`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Tags of the resource.

### privateEndpointVnetResourceGroup

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Existing Private Endpoint Vnet Resource Group

### privateEndpointVnetName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Existing Private Endpoint Vnet Name

### privateEndpointSubnetName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Existing Private Endpoint Subnet Name

### keyVaultName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the key vault

### keyVaultPrivateEndpointName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

The name of the key vault private endpoint

### keyVaultPrivateEndpointIP

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The static IP address assigned to the Private Endpoint for the Key Vault

### storageAccountName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. Name of the storage account.

### blobContainers

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. list of Additional blob containers to be created in the Synapse Storage Account.

### storageAccountBlobPrivateEndpointName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Name of the Blob Private Endpoint for the Storage Account

### storageAccountBlobPrivateEndpointIP

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The static IP address assigned to the Blob Private Endpoint for the Storage Account

### storageAccountDfsPrivateEndpointName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Name of the Dfs Private Endpoint for the Storage Account

### storageAccountDfsPrivateEndpointIP

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The static IP address assigned to the Dfs Private Endpoint for the Storage Account

## Outputs

Name | Type | Description
---- | ---- | -----------
storageAccountName | string |
storageAccountResourceId | string |
storageAccountUserAssignedIdentityResourceId | string |
storageAccountUserAssignedIdentityPrincipalId | string |
keyVaultName | string |
keyVaultResourceId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "./templates/demo/main.json"
    },
    "parameters": {
        "location": {
            "value": "[resourceGroup().location]"
        },
        "tags": {
            "value": {}
        },
        "privateEndpointVnetResourceGroup": {
            "value": ""
        },
        "privateEndpointVnetName": {
            "value": ""
        },
        "privateEndpointSubnetName": {
            "value": ""
        },
        "keyVaultName": {
            "value": ""
        },
        "keyVaultPrivateEndpointName": {
            "value": ""
        },
        "keyVaultPrivateEndpointIP": {
            "value": ""
        },
        "storageAccountName": {
            "value": ""
        },
        "blobContainers": {
            "value": []
        },
        "storageAccountBlobPrivateEndpointName": {
            "value": ""
        },
        "storageAccountBlobPrivateEndpointIP": {
            "value": ""
        },
        "storageAccountDfsPrivateEndpointName": {
            "value": ""
        },
        "storageAccountDfsPrivateEndpointIP": {
            "value": ""
        }
    }
}
```

