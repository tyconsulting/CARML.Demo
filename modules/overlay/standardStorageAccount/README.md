# Standard Storage Account Bicep module

Deploys a standard Storage Account that aligns with the company standard.

This module deploys a standard Storage Account that aligns with the company standard.

## Parameters

Parameter name | Required | Description
-------------- | -------- | -----------
storageAccountName | Yes      | Name of the Storage Account
location       | No       | Location for all Resources.
accessTier     | No       | Optional. Storage Account Access Tier.
tags           | No       | Optional. Tags of the resource.
skuName        | No       | The name of the SKU
kind           | No       | Specifies the kind of storage
managementPoliciesRules | No       | Optional. The Storage Account ManagementPolicies Rules.
cMKKeyVaultResourceId | Yes      | Required. The resource ID of a key vault to reference a customer managed key for encryption from.
cMKUserAssignedIdentityName | No       | Required. Name of the User assigned identity to use when fetching the customer managed key.
enableHierarchicalNamespace | No       | Optional. Enable Hierarchical Namespace. Default is set to false. It must be set to true to enable SFTP. This is automatically enabled if enableSFTP is set to true.
configureBlobService | No       | Optional. Specify if blob service should be configured. Default value is set to true.
blobDeleteRetentionPolicy | No       | Optional. Indicates whether DeleteRetentionPolicy is enabled for the Blob service.
blobDeleteRetentionPolicyDays | No       | Optional. Indicates the number of days that the deleted blob should be retained. The minimum specified value can be 1 and the maximum value can be 365.
configureFileService | No       | Optional. Specify if file service should be configured. Default value is set to false.
fileDeleteRetentionPolicy | No       | Optional. Indicates whether DeleteRetentionPolicy is enabled for the File service.
fileDeleteRetentionPolicyDays | No       | Optional. Indicates the number of days that the deleted file shares should be retained. The minimum specified value can be 1 and the maximum value can be 365.
enableLocalUser | No       | Optional. Enable Local User. Default is set to false. It must be set to true to enable SFTP. This is automatically enabled if enableSFTP is set to true.
enableSftp     | No       | Optional. Enable SFTP. Default is set to false. It must be set to true to enable SFTP
largeFileSharesState | No       | Optional. Allow large file shares if sets to Enabled. It cannot be disabled once it is enabled.. Default value is Disabled
azureFilesIdentityBasedAuthentication | No       | Optional. Provides the identity based authentication settings for Azure Files.
customDomainName | No       | Optional. Sets the custom domain name assigned to the storage account. Name is the CNAME source.
customDomainUseSubDomainName | No       | Optional. Indicates whether indirect CName validation is enabled. This should only be set on updates.
defaultToOAuthAuthentication | No       | Optional. A boolean flag which indicates whether the default authentication is OAuth or not.
blobPrivateEndpointName | No       | Conditional. Name of the blob Private Endpoint. Required for the blob Private Endpoint.
blobPrivateEndpointNicName | No       | Optional. The custom name of the network interface attached to the blob private endpoint.
blobPrivateEndpointIP | No       | Optional. The static privavte IP address for the blob private endpoint.
filePrivateEndpointName | No       | Conditional. Name of the file Private Endpoint. Required for the file Private Endpoint.
filePrivateEndpointNicName | No       | Optional. The custom name of the network interface attached to the file private endpoint.
filePrivateEndpointIP | No       | Optional. The static privavte IP address for the file private endpoint.
dfsPrivateEndpointName | No       | Conditional. Name of the ADLS Private Endpoint. Required for the dfs Private Endpoint.
dfsPrivateEndpointNicName | No       | Optional. The custom name of the network interface attached to the dfs private endpoint.
dfsPrivateEndpointIP | No       | Optional. The static privavte IP address for the dfs private endpoint.
blobContainers | No       | Optional. list of blob containers to be created in the Storage Account.
fileShares     | No       | Optional. list of file shares to be created in the Storage Account.
localUserName  | No       | Optional. Name of the Storage Account SFTP Local User.
localUserHomeDirectory | No       | Conditional. Name of the Staging Storage Account local user's home directory. It will be created automatically if not specified in the 'blobContainer' parameter. Requird for SFTP.
localUserPublicKey | No       | Conditional. SSH Public Key for the Storage Account SFTP local user. Required for SFTP
localUserPermissionScopes | No       | Optional. The permission scopes of the Storage Account SFTP local user. the home directory will automatically grant full access to the local user.
enableNfsV3    | No       | Optional. If true, enables NFS 3.0 support for the storage account. Requires enableHierarchicalNamespace to be true.
subnetResourceId | No       | Conditional. Existing Subnet Resource ID to assign to the Private Endpoint. Required for Private Endpoint.

### storageAccountName

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Name of the Storage Account

### location

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Location for all Resources.

- Default value: `australiaeast`

### accessTier

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Storage Account Access Tier.

- Default value: `Hot`

- Allowed values: `Hot`, `Cool`

### tags

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Tags of the resource.

### skuName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

The name of the SKU

- Default value: `Standard_LRS`

- Allowed values: `Premium_LRS`, `Premium_ZRS`, `Standard_GRS`, `Standard_GZRS`, `Standard_LRS`, `Standard_RAGRS`, `Standard_RAGZRS`, `Standard_ZRS`

### kind

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Specifies the kind of storage

- Default value: `StorageV2`

- Allowed values: `StorageV2`, `BlobStorage`, `FileStorage`

### managementPoliciesRules

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The Storage Account ManagementPolicies Rules.

### cMKKeyVaultResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-required-orange?style=flat-square)

Required. The resource ID of a key vault to reference a customer managed key for encryption from.

### cMKUserAssignedIdentityName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Required. Name of the User assigned identity to use when fetching the customer managed key.

### enableHierarchicalNamespace

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Enable Hierarchical Namespace. Default is set to false. It must be set to true to enable SFTP. This is automatically enabled if enableSFTP is set to true.

- Default value: `False`

### configureBlobService

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Specify if blob service should be configured. Default value is set to true.

- Default value: `True`

### blobDeleteRetentionPolicy

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Indicates whether DeleteRetentionPolicy is enabled for the Blob service.

- Default value: `True`

### blobDeleteRetentionPolicyDays

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Indicates the number of days that the deleted blob should be retained. The minimum specified value can be 1 and the maximum value can be 365.

- Default value: `7`

### configureFileService

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Specify if file service should be configured. Default value is set to false.

- Default value: `False`

### fileDeleteRetentionPolicy

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Indicates whether DeleteRetentionPolicy is enabled for the File service.

- Default value: `True`

### fileDeleteRetentionPolicyDays

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Indicates the number of days that the deleted file shares should be retained. The minimum specified value can be 1 and the maximum value can be 365.

- Default value: `7`

### enableLocalUser

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Enable Local User. Default is set to false. It must be set to true to enable SFTP. This is automatically enabled if enableSFTP is set to true.

- Default value: `False`

### enableSftp

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Enable SFTP. Default is set to false. It must be set to true to enable SFTP

- Default value: `False`

### largeFileSharesState

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Allow large file shares if sets to Enabled. It cannot be disabled once it is enabled.. Default value is Disabled

- Default value: `Disabled`

- Allowed values: `Disabled`, `Enabled`

### azureFilesIdentityBasedAuthentication

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Provides the identity based authentication settings for Azure Files.

### customDomainName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Sets the custom domain name assigned to the storage account. Name is the CNAME source.

### customDomainUseSubDomainName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Indicates whether indirect CName validation is enabled. This should only be set on updates.

- Default value: `False`

### defaultToOAuthAuthentication

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. A boolean flag which indicates whether the default authentication is OAuth or not.

- Default value: `False`

### blobPrivateEndpointName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Conditional. Name of the blob Private Endpoint. Required for the blob Private Endpoint.

### blobPrivateEndpointNicName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The custom name of the network interface attached to the blob private endpoint.

### blobPrivateEndpointIP

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The static privavte IP address for the blob private endpoint.

### filePrivateEndpointName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Conditional. Name of the file Private Endpoint. Required for the file Private Endpoint.

### filePrivateEndpointNicName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The custom name of the network interface attached to the file private endpoint.

### filePrivateEndpointIP

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The static privavte IP address for the file private endpoint.

### dfsPrivateEndpointName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Conditional. Name of the ADLS Private Endpoint. Required for the dfs Private Endpoint.

### dfsPrivateEndpointNicName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The custom name of the network interface attached to the dfs private endpoint.

### dfsPrivateEndpointIP

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The static privavte IP address for the dfs private endpoint.

### blobContainers

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. list of blob containers to be created in the Storage Account.

### fileShares

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. list of file shares to be created in the Storage Account.

### localUserName

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. Name of the Storage Account SFTP Local User.

### localUserHomeDirectory

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Conditional. Name of the Staging Storage Account local user's home directory. It will be created automatically if not specified in the 'blobContainer' parameter. Requird for SFTP.

### localUserPublicKey

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Conditional. SSH Public Key for the Storage Account SFTP local user. Required for SFTP

### localUserPermissionScopes

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. The permission scopes of the Storage Account SFTP local user. the home directory will automatically grant full access to the local user.

### enableNfsV3

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Optional. If true, enables NFS 3.0 support for the storage account. Requires enableHierarchicalNamespace to be true.

- Default value: `False`

### subnetResourceId

![Parameter Setting](https://img.shields.io/badge/parameter-optional-green?style=flat-square)

Conditional. Existing Subnet Resource ID to assign to the Private Endpoint. Required for Private Endpoint.

## Outputs

Name | Type | Description
---- | ---- | -----------
name | string |
resourceId | string |
userAssignedIdentityResourceId | string |
userAssignedIdentityPrincipalId | string |

## Snippets

### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "metadata": {
        "template": "./modules/overlay/standardStorageAccount/main.json"
    },
    "parameters": {
        "storageAccountName": {
            "value": ""
        },
        "location": {
            "value": "australiaeast"
        },
        "accessTier": {
            "value": "Hot"
        },
        "tags": {
            "value": {}
        },
        "skuName": {
            "value": "Standard_LRS"
        },
        "kind": {
            "value": "StorageV2"
        },
        "managementPoliciesRules": {
            "value": []
        },
        "cMKKeyVaultResourceId": {
            "value": ""
        },
        "cMKUserAssignedIdentityName": {
            "value": ""
        },
        "enableHierarchicalNamespace": {
            "value": false
        },
        "configureBlobService": {
            "value": true
        },
        "blobDeleteRetentionPolicy": {
            "value": true
        },
        "blobDeleteRetentionPolicyDays": {
            "value": 7
        },
        "configureFileService": {
            "value": false
        },
        "fileDeleteRetentionPolicy": {
            "value": true
        },
        "fileDeleteRetentionPolicyDays": {
            "value": 7
        },
        "enableLocalUser": {
            "value": false
        },
        "enableSftp": {
            "value": false
        },
        "largeFileSharesState": {
            "value": "Disabled"
        },
        "azureFilesIdentityBasedAuthentication": {
            "value": {}
        },
        "customDomainName": {
            "value": ""
        },
        "customDomainUseSubDomainName": {
            "value": false
        },
        "defaultToOAuthAuthentication": {
            "value": false
        },
        "blobPrivateEndpointName": {
            "value": ""
        },
        "blobPrivateEndpointNicName": {
            "value": ""
        },
        "blobPrivateEndpointIP": {
            "value": ""
        },
        "filePrivateEndpointName": {
            "value": ""
        },
        "filePrivateEndpointNicName": {
            "value": ""
        },
        "filePrivateEndpointIP": {
            "value": ""
        },
        "dfsPrivateEndpointName": {
            "value": ""
        },
        "dfsPrivateEndpointNicName": {
            "value": ""
        },
        "dfsPrivateEndpointIP": {
            "value": ""
        },
        "blobContainers": {
            "value": []
        },
        "fileShares": {
            "value": []
        },
        "localUserName": {
            "value": ""
        },
        "localUserHomeDirectory": {
            "value": ""
        },
        "localUserPublicKey": {
            "value": ""
        },
        "localUserPermissionScopes": {
            "value": []
        },
        "enableNfsV3": {
            "value": false
        },
        "subnetResourceId": {
            "value": ""
        }
    }
}
```

