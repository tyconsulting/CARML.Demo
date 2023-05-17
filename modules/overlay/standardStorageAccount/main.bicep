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

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Specifies the default action of allow or deny when no other rules match')
@allowed([
  'Allow'
  'Deny'
])
param networkAclsDefaultAction string = 'Deny'

@description('Optional. Indicates whether public access is enabled for all blobs or containers in the storage account. For security reasons, it is recommended to set it to false.')
param allowBlobPublicAccess bool = false

@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
])
@description('Optional. Set the minimum TLS version on request to storage.')
param minimumTlsVersion string = 'TLS1_2'

@description('Optional. Enable or disable public network access to Storage Account..')
param publicNetworkAccess string = 'Disabled'

@description('Optional. Allows HTTPS traffic only to storage service if sets to true.')
param supportsHttpsTrafficOnly bool = true

@description('Optional. Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key. If false, then all requests, including shared access signatures, must be authorized with Azure Active Directory (Azure AD). Default is set to false')
param allowSharedKeyAccess bool = false

@description('Optional. Virtual Network Rules')
param virtualNetworkRules array = []

@description('Optional. IP Rules')
param ipRules array = []

@description('Optional. The Storage Account ManagementPolicies Rules.')
param managementPoliciesRules array = []

@description('Optional. Allow or disallow cross AAD tenant object replication. Default is set to false')
param allowCrossTenantReplication bool = false

@description('Optional. Enable Infrastructure encryption. Default is set to true')
param infrastructureEncryptionEnabled bool = true

@description('Optional. The resource ID of a key vault to reference a customer managed key for encryption from.')
param cMKKeyVaultResourceId string = ''

@description('Optional. The name of the customer managed key to use for encryption. This is required if \'cMKKeyVaultResourceId\' is specified.')
param cMKKeyName string = ''

@description('Optional. The version of the customer managed key to reference for encryption. If not provided, latest is used.')
param cMKKeyVersion string = ''

@description('Conditional. User assigned identity to use when fetching the customer managed key. Required if \'cMKKeyName\' is not empty.')
param cMKUserAssignedIdentityResourceId string = ''

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
param subnetId string = ''

var deploymentNameSuffix = last(split(deployment().name, '-'))
var KeyVaultCryptoServiceEncryptionUserRole = '/providers/Microsoft.Authorization/roleDefinitions/e147488a-f6f5-4113-8e2d-b22465e65bf6'
var cMKKeyVaultSubId = !empty(cMKKeyVaultResourceId) ? split(cMKKeyVaultResourceId, '/')[2] : ''
var cMKKeyVaultRGName = !empty(cMKKeyVaultResourceId) ? split(cMKKeyVaultResourceId, '/')[4] : ''
var cMKKeyVaultName = !empty(cMKKeyVaultResourceId) ? split(cMKKeyVaultResourceId, '/')[8] : ''
var combinedLocalUserPermissionScopes = concat(localUserPermissionScopes, array({
    permissions: 'rcwdl'
    service: 'blob'
    resourceName: localUserHomeDirectory
  }))
var enableHns = enableSftp ? true : enableHierarchicalNamespace

module standardStorageAccount '../../carml/storage/storageAccounts/main.bicep' = {
  name: take('StdStorage-${storageAccountName}-${deploymentNameSuffix}', 64)
  params: {
    name: storageAccountName
    location: location
    tags: tags
    systemAssignedIdentity: systemAssignedIdentity
    kind: kind
    skuName: skuName
    accessTier: accessTier
    largeFileSharesState: largeFileSharesState
    azureFilesIdentityBasedAuthentication: azureFilesIdentityBasedAuthentication
    defaultToOAuthAuthentication: defaultToOAuthAuthentication
    allowSharedKeyAccess: false
    privateEndpoints: []
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
      containers: blobContainers
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
    localUsers: [
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
    ]
    enableNfsV3: enableNfsV3
    allowedCopyScope: 'AAD'
    publicNetworkAccess: 'Disabled'
    supportsHttpsTrafficOnly: true
    cMKKeyVaultResourceId: cMKKeyVaultResourceId
    cMKKeyName: cMKKeyName
    cMKUserAssignedIdentityResourceId: cMKUserAssignedIdentityResourceId
  }
}

/*
module standardStorageAccount1 '../../carml/storage/storageAccounts/main.bicep' = {
  name: take('StdStorage-${storageAccountName}-${deploymentNameSuffix}', 64)
  params: {
    storageAccountName: storageAccountName
    location: location
    tagvalues: tagvalues
    storageAccountAccessTier: storageAccountAccessTier
    sku: sku
    kind: kind
    networkAclsDefaultAction: networkAclsDefaultAction
    allowBlobPublicAccess: allowBlobPublicAccess
    minimumTlsVersion: minimumTlsVersion
    publicNetworkAccess: publicNetworkAccess
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
    enableHierarchicalNamespace: enableHierarchicalNamespace
    allowSharedKeyAccess: allowSharedKeyAccess
    virtualNetworkRules: virtualNetworkRules
    ipRules: ipRules
    allowCrossTenantReplication: allowCrossTenantReplication
    allowedCopyScope: allowedCopyScope
    infrastructureEncryptionEnabled: infrastructureEncryptionEnabled
    enableLocalUser: enableLocalUser
    enableSFTP: enableSFTP
    largeFileSharesState: largeFileSharesState
    configureBlobService: configureBlobService
    configureFileService: configureFileService
    blobDeleteRetentionPolicy: blobDeleteRetentionPolicy
    blobDeleteRetentionPolicyDays: blobDeleteRetentionPolicyDays
    fileDeleteRetentionPolicy: fileDeleteRetentionPolicy
    fileDeleteRetentionPolicyDays: fileDeleteRetentionPolicyDays
  }
}
*/
module deployMgmtPoliciesRules '../../microsoft.storage/storageAccounts/managementPolicies/main.bicep' = if (!empty(managementPoliciesRules)) {
  name: take('UDP-mgmtPoliciesRules-${storageAccountName}-${deploymentNameSuffix}', 64)
  params: {
    storageAccountName: storageAccountName
    rules: managementPoliciesRules
  }
  dependsOn: [
    deploySA
  ]
}
module deployBlobPE '../../microsoft.network/privateEndpoints/main.bicep' = if (!empty(blobPrivateEndpointName)) {
  name: take('UDP-deployBlobPe-${storageAccountName}-${deploymentNameSuffix}', 64)
  params: {
    privateEndpointName: blobPrivateEndpointName
    tagvalues: tagvalues
    subnetId: subnetId
    privateLinkServiceId: deploySA.outputs.storageAccountResourceId
    groupId: 'blob'
    customNetworkInterfaceName: blobPrivateEndpointNicName
    staticPrivateIPAddress: blobPrivateEndpointIP
    ipConfigurationMemberName: 'blob'
  }
}

module deployFilePE '../../microsoft.network/privateEndpoints/main.bicep' = if (!empty(filePrivateEndpointName)) {
  name: take('UDP-deployFilePe-${storageAccountName}-${deploymentNameSuffix}', 64)
  params: {
    privateEndpointName: filePrivateEndpointName
    tagvalues: tagvalues
    subnetId: subnetId
    privateLinkServiceId: deploySA.outputs.storageAccountResourceId
    groupId: 'file'
    customNetworkInterfaceName: filePrivateEndpointNicName
    staticPrivateIPAddress: filePrivateEndpointIP
    ipConfigurationMemberName: 'file'
  }
}

module deployDfsPE '../../microsoft.network/privateEndpoints/main.bicep' = if (!empty(dfsPrivateEndpointName)) {
  name: take('UDP-deployDfsPe-${storageAccountName}-${deploymentNameSuffix}', 64)
  params: {
    privateEndpointName: dfsPrivateEndpointName
    tagvalues: tagvalues
    subnetId: subnetId
    privateLinkServiceId: deploySA.outputs.storageAccountResourceId
    groupId: 'dfs'
    customNetworkInterfaceName: dfsPrivateEndpointNicName
    staticPrivateIPAddress: dfsPrivateEndpointIP
    ipConfigurationMemberName: 'dfs'
  }
}

module kvRoleAssignment '../../microsoft.authorization/roleAssignments/main.bicep' = if (!empty(cMKKeyVaultResourceId)) {
  name: take('UDP-${storageAccountName}-kv-rbac-${deploymentNameSuffix}', 64)
  scope: resourceGroup(cMKKeyVaultSubId, cMKKeyVaultRGName)
  params: {
    roleDefinitionId: KeyVaultCryptoServiceEncryptionUserRole
    principalId: deploySA.outputs.storageAccountIdentityPrincipalId
    principalType: 'ServicePrincipal'
  }
}

module deploysftpUserHomeBlobContainers '../../microsoft.storage/storageAccounts/blobServices/containers/main.bicep' = if (!contains(blobContainers, localUserHomeDirectory) && !empty(localUserHomeDirectory)) {
  name: 'UDP-${storageAccountName}-sftpUserHomeContainer'
  dependsOn: [
    deploySA
  ]
  params: {
    storageAccountName: storageAccountName
    name: localUserHomeDirectory
    publicAccess: 'None'
  }
}
output storageAccountName string = deploySA.outputs.storageAccountName
output storageAccountResourceId string = deploySA.outputs.storageAccountResourceId
output storageAccountIdentityPrincipalId string = deploySA.outputs.storageAccountIdentityPrincipalId
output blobPrivateEndpointResourceId string = !empty(blobPrivateEndpointName) ? deployBlobPE.outputs.privateEndpointResourceId : ''
output filePrivateEndpointResourceId string = !empty(filePrivateEndpointName) ? deployFilePE.outputs.privateEndpointResourceId : ''
output dfsPrivateEndpointResourceId string = !empty(dfsPrivateEndpointName) ? deployDfsPE.outputs.privateEndpointResourceId : ''
