@description('Name of the Storage Account')
param storageAccountName string

@description('Location for all Resources.')
param location string = 'australiaeast'

@allowed([
  'Hot'
  'Cool'
])
@description('Optional. Storage Account Access Tier.')
param accessTier string = 'Hot'

@description('Optional. Tags of the resource.')
param tags object = {}

@description('The name of the SKU')
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param skuName string = 'Standard_LRS'

@description('Specifies the kind of storage')
@allowed([
  'StorageV2'
  'BlobStorage'
  'FileStorage'
])
param kind string = 'StorageV2'

@description('Optional. The Storage Account ManagementPolicies Rules.')
param managementPoliciesRules array = []

@description('Required. The resource ID of a key vault to reference a customer managed key for encryption from.')
param cMKKeyVaultResourceId string

@description('Required. Name of the User assigned identity to use when fetching the customer managed key.')
param cMKUserAssignedIdentityName string = ''

@description('Optional. Enable Hierarchical Namespace. Default is set to false. It must be set to true to enable SFTP. This is automatically enabled if enableSFTP is set to true.')
param enableHierarchicalNamespace bool = false

@description('Optional. Specify if blob service should be configured. Default value is set to true.')
param configureBlobService bool = true

@description('Optional. Indicates whether DeleteRetentionPolicy is enabled for the Blob service.')
param blobDeleteRetentionPolicy bool = true

@description('Optional. Indicates the number of days that the deleted blob should be retained. The minimum specified value can be 1 and the maximum value can be 365.')
param blobDeleteRetentionPolicyDays int = 7

@description('Optional. Specify if file service should be configured. Default value is set to false.')
param configureFileService bool = false

@description('Optional. Indicates whether DeleteRetentionPolicy is enabled for the File service.')
param fileDeleteRetentionPolicy bool = true

@description('Optional. Indicates the number of days that the deleted file shares should be retained. The minimum specified value can be 1 and the maximum value can be 365.')
param fileDeleteRetentionPolicyDays int = 7

@description('Optional. Enable Local User. Default is set to false. It must be set to true to enable SFTP. This is automatically enabled if enableSFTP is set to true.')
param enableLocalUser bool = false

@description('Optional. Enable SFTP. Default is set to false. It must be set to true to enable SFTP')
param enableSftp bool = false

@description('Optional. Allow large file shares if sets to Enabled. It cannot be disabled once it is enabled.. Default value is Disabled')
@allowed([
  'Disabled'
  'Enabled'
])
param largeFileSharesState string = 'Disabled'

@description('Optional. Provides the identity based authentication settings for Azure Files.')
param azureFilesIdentityBasedAuthentication object = {}

@description('Optional. Sets the custom domain name assigned to the storage account. Name is the CNAME source.')
param customDomainName string = ''

@description('Optional. Indicates whether indirect CName validation is enabled. This should only be set on updates.')
param customDomainUseSubDomainName bool = false

@description('Optional. A boolean flag which indicates whether the default authentication is OAuth or not.')
param defaultToOAuthAuthentication bool = false

@description('Conditional. Name of the blob Private Endpoint. Required for the blob Private Endpoint.')
param blobPrivateEndpointName string = ''

@description('Optional. The custom name of the network interface attached to the blob private endpoint.')
param blobPrivateEndpointNicName string = ''

@description('Optional. The static privavte IP address for the blob private endpoint.')
param blobPrivateEndpointIP string = ''

@description('Conditional. Name of the file Private Endpoint. Required for the file Private Endpoint.')
param filePrivateEndpointName string = ''

@description('Optional. The custom name of the network interface attached to the file private endpoint.')
param filePrivateEndpointNicName string = ''

@description('Optional. The static privavte IP address for the file private endpoint.')
param filePrivateEndpointIP string = ''

@description('Conditional. Name of the ADLS Private Endpoint. Required for the dfs Private Endpoint.')
param dfsPrivateEndpointName string = ''

@description('Optional. The custom name of the network interface attached to the dfs private endpoint.')
param dfsPrivateEndpointNicName string = ''

@description('Optional. The static privavte IP address for the dfs private endpoint.')
param dfsPrivateEndpointIP string = ''

@description('Optional. list of blob containers to be created in the Storage Account.')
param blobContainers array = []

@description('Optional. list of file shares to be created in the Storage Account.')
param fileShares array = []

@description('Optional. Name of the Storage Account SFTP Local User.')
param localUserName string = ''

@description('Conditional. Name of the Staging Storage Account local user\'s home directory. It will be created automatically if not specified in the \'blobContainer\' parameter. Requird for SFTP.')
param localUserHomeDirectory string = ''

@description('Conditional. SSH Public Key for the Storage Account SFTP local user. Required for SFTP')
param localUserPublicKey string = ''

@description('Optional. The permission scopes of the Storage Account SFTP local user. the home directory will automatically grant full access to the local user.')
param localUserPermissionScopes array = []

@description('Optional. If true, enables NFS 3.0 support for the storage account. Requires enableHierarchicalNamespace to be true.')
param enableNfsV3 bool = false

@description('Conditional. Existing Subnet Resource ID to assign to the Private Endpoint. Required for Private Endpoint.')
param subnetResourceId string = ''

var deploymentNameSuffix = last(split(deployment().name, '-'))
var KeyVaultCryptoServiceEncryptionUserRole = '/providers/Microsoft.Authorization/roleDefinitions/e147488a-f6f5-4113-8e2d-b22465e65bf6'
var cMKKeyVaultSubId = !empty(cMKKeyVaultResourceId) ? split(cMKKeyVaultResourceId, '/')[2] : ''
var cMKKeyVaultRGName = !empty(cMKKeyVaultResourceId) ? split(cMKKeyVaultResourceId, '/')[4] : ''
var cMKKeyVaultName = !empty(cMKKeyVaultResourceId) ? split(cMKKeyVaultResourceId, '/')[8] : ''
var cMKKeyName = 'cmkkey-${storageAccountName}'
var combinedLocalUserPermissionScopes = concat(localUserPermissionScopes, array({
    permissions: 'rcwdl'
    service: 'blob'
    resourceName: localUserHomeDirectory
  }))
var enableHns = enableSftp ? true : enableHierarchicalNamespace
var blobPe = !empty(blobPrivateEndpointName) ? [
  {
    name: blobPrivateEndpointName
    service: 'blob'
    subnetResourceId: subnetResourceId
    customNetworkInterfaceName: blobPrivateEndpointNicName
    tags: tags
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'blob'
          memberName: 'blob'
          privateIPAddress: !empty(blobPrivateEndpointIP) ? blobPrivateEndpointIP : null
        }
      }
    ]
  }
] : []

var dfsPe = !empty(dfsPrivateEndpointName) ? [
  {
    name: dfsPrivateEndpointName
    service: 'dfs'
    subnetResourceId: subnetResourceId
    customNetworkInterfaceName: dfsPrivateEndpointNicName
    tags: tags
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'dfs'
          memberName: 'dfs'
          privateIPAddress: !empty(dfsPrivateEndpointIP) ? dfsPrivateEndpointIP : null
        }
      }
    ]
  }
] : []

var filePe = !empty(filePrivateEndpointName) ? [
  {
    name: filePrivateEndpointName
    service: 'file'
    subnetResourceId: subnetResourceId
    customNetworkInterfaceName: filePrivateEndpointNicName
    tags: tags
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'file'
          memberName: 'file'
          privateIPAddress: !empty(filePrivateEndpointIP) ? filePrivateEndpointIP : null
        }
      }
    ]
  }
] : []

var combinedPes = concat(blobPe, dfsPe, filePe)

var combinedContainers = !contains(blobContainers, localUserHomeDirectory) && !empty(localUserHomeDirectory) ? concat(blobContainers, array(localUserHomeDirectory)) : blobContainers
var containerObjectArray = [for c in combinedContainers: {
  name: c
}]
module cMKMI '../../carml/ManagedIdentity/userAssignedIdentities/main.bicep' = {
  name: take('mi-${storageAccountName}-${deploymentNameSuffix}', 64)
  params: {
    name: cMKUserAssignedIdentityName
    location: location
    tags: tags
  }
}
module standardStorageAccount '../../carml/storage/storageAccounts/main.bicep' = {
  name: take('StdStorage-${storageAccountName}-${deploymentNameSuffix}', 64)
  dependsOn: [
    kvRoleAssignment
  ]
  params: {
    name: storageAccountName
    location: location
    tags: tags
    systemAssignedIdentity: false
    userAssignedIdentities: {
      '${cMKMI.outputs.resourceId}': {}
    }
    kind: kind
    skuName: skuName
    accessTier: accessTier
    largeFileSharesState: largeFileSharesState
    azureFilesIdentityBasedAuthentication: azureFilesIdentityBasedAuthentication
    defaultToOAuthAuthentication: defaultToOAuthAuthentication
    allowSharedKeyAccess: false
    privateEndpoints: combinedPes
    managementPolicyRules: managementPoliciesRules
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
      ipRules: []
      virtualNetworkRules: []
    }
    requireInfrastructureEncryption: true
    allowCrossTenantReplication: false
    customDomainName: customDomainName
    customDomainUseSubDomainName: customDomainUseSubDomainName
    blobServices: configureBlobService ? {
      containers: containerObjectArray
      deleteRetentionPolicy: blobDeleteRetentionPolicy
      deleteRetentionPolicyDays: blobDeleteRetentionPolicyDays
    } : {}
    fileServices: configureFileService ? {
      shares: fileShares
      shareDeleteRetentionPolicy: {
        enabled: fileDeleteRetentionPolicy
        days: fileDeleteRetentionPolicyDays
      }
      protocolSettings: {
        smb: {
          authenticationMethods: 'Kerberos'
          channelEncryption: 'AES-256-GCM'
          kerberosTicketEncryption: 'AES-256'
          multichannel: {
            enabled: kind == 'FileStorage' && startsWith(skuName, 'Premium') ? true : false
          }
          versions: 'SMB3.0;SMB3.1.1'
        }
      }
    } : {}
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    enableHierarchicalNamespace: enableHns
    enableSftp: enableSftp
    isLocalUserEnabled: enableSftp ? true : enableLocalUser
    localUsers: !empty(localUserName) ? [
      {
        name: localUserName
        hasSharedKey: false
        hasSshPassword: false
        hasSshKey: true
        homeDirectory: localUserHomeDirectory
        sshAuthorizedKeys: empty(localUserPublicKey) ? null : [
          {
            key: localUserPublicKey
            description: 'Public Key for user ${localUserName}'
          }
        ]
        permissionScopes: combinedLocalUserPermissionScopes
      }
    ] : []
    enableNfsV3: enableNfsV3
    allowedCopyScope: 'AAD'
    publicNetworkAccess: 'Disabled'
    supportsHttpsTrafficOnly: true
    cMKKeyVaultResourceId: cMKKeyVaultResourceId
    cMKKeyName: cMKKey.outputs.name
    cMKUserAssignedIdentityResourceId: cMKMI.outputs.resourceId
  }
}

module kvRoleAssignment '../../carml/KeyVault/vaults/.bicep/nested_roleAssignments.bicep' = {
  name: take('${storageAccountName}-kv-rbac-${deploymentNameSuffix}', 64)
  scope: resourceGroup(cMKKeyVaultSubId, cMKKeyVaultRGName)
  params: {
    roleDefinitionIdOrName: KeyVaultCryptoServiceEncryptionUserRole
    resourceId: cMKKeyVaultResourceId
    principalIds: [ cMKMI.outputs.principalId ]
    principalType: 'ServicePrincipal'
  }
}

module cMKKey '../../carml/KeyVault/vaults/keys/main.bicep' = {
  name: take('cMKKey-${storageAccountName}-${deploymentNameSuffix}', 64)
  scope: resourceGroup(cMKKeyVaultSubId, cMKKeyVaultRGName)
  params: {
    name: cMKKeyName
    keyVaultName: cMKKeyVaultName
    keySize: 2048
    kty: 'RSA'
    keyOps: [
      'encrypt'
      'decrypt'
      'sign'
      'verify'
      'wrapKey'
      'unwrapKey'
    ]
    attributesEnabled: true
  }
}

output name string = standardStorageAccount.outputs.name
output resourceId string = standardStorageAccount.outputs.resourceId
output userAssignedIdentityResourceId string = cMKMI.outputs.resourceId
output userAssignedIdentityPrincipalId string = cMKMI.outputs.principalId
