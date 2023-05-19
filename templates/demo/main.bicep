targetScope = 'resourceGroup'
// ---------- Common Parameters ----------
@description('Name of the existing Resource Group')
param resourceGroupName string

@description('Optional. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Existing Private Endpoint Vnet Resource Group')
param privateEndpointVnetResourceGroup string

@description('Existing Private Endpoint Vnet Name')
param privateEndpointVnetName string

@description('Existing Private Endpoint Subnet Name')
param privateEndpointSubnetName string

// ---------- Key Vault Parameters ----------
@description('The name of the key vault')
param keyVaultName string

@description('The name of the key vault private endpoint')
param keyVaultPrivateEndpointName string

@description('Optional. The static IP address assigned to the Private Endpoint for the Key Vault')
param keyVaultPrivateEndpointIP string = ''

// ---------- Storage Account Parameters ----------
@description('Required. Name of the storage account.')
param storageAccountName string

@description('Optional. list of Additional blob containers to be created in the Synapse Storage Account.')
param blobContainers array = []

@description('Name of the Blob Private Endpoint for the Storage Account')
param storageAccountBlobPrivateEndpointName string

@description('Optional. The static IP address assigned to the Blob Private Endpoint for the Storage Account')
param storageAccountBlobPrivateEndpointIP string = ''

@description('Name of the Dfs Private Endpoint for the Storage Account')
param storageAccountDfsPrivateEndpointName string

@description('Optional. The static IP address assigned to the Dfs Private Endpoint for the Storage Account')
param storageAccountDfsPrivateEndpointIP string = ''

// ---------- Variables ----------
var deploymentNameSuffix = last(split(deployment().name, '-'))
var kvPeNicName = 'nic-${keyVaultPrivateEndpointName}'
var storageBlobPeNicName = 'nic-${storageAccountBlobPrivateEndpointName}'
var storageDfsPeNicName = 'nic-${storageAccountDfsPrivateEndpointName}'

// ---------- Resources ----------
//Lookup PE subnet

resource peVnet 'microsoft.network/virtualNetworks@2022-07-01' existing = {
  name: privateEndpointVnetName
  scope: resourceGroup(privateEndpointVnetResourceGroup)

  resource peSubnet 'subnets' existing = {
    name: privateEndpointSubnetName
  }
}

// ---------- Key Vault ----------
module kv '../../modules/carml/KeyVault/vaults/main.bicep' = {
  name: take('Kv-${deploymentNameSuffix}', 64)
  params: {
    tags: tags
    name: keyVaultName
    vaultSku: 'standard'
    privateEndpoints: [
      {
        name: keyVaultPrivateEndpointName
        subnetId: peVnet::peSubnet.id
        customNetworkInterfaceName: kvPeNicName
        tags: tags
        ipConfigurations: [
          {
            name: 'ipconfig1'
            properties: {
              groupId: 'vault'
              memberName: 'default'
              privateIPAddress: !empty(keyVaultPrivateEndpointIP) ? keyVaultPrivateEndpointIP : null
            }
          }
        ]
      }
    ]
    enableRbacAuthorization: true
    enablePurgeProtection: true
    enableSoftDelete: true
    enableVaultForDeployment: true
  }
}

module storage '../../modules/overlay/standardStorageAccount/main.bicep' = {
  name: take('sa-${deploymentNameSuffix}', 64)
  params: {
    storageAccountName: storageAccountName
    location: location
    tags: tags
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    accessTier: 'Hot'
    systemAssignedIdentity: true
    cMKKeyVaultResourceId: kv.outputs.resourceId
    cMKUserAssignedIdentityName: 'mi-${storageAccountName}'
    enableHierarchicalNamespace: true
    blobPrivateEndpointName: storageAccountBlobPrivateEndpointName
    blobPrivateEndpointIP: storageAccountBlobPrivateEndpointIP
    blobPrivateEndpointNicName: storageBlobPeNicName
    dfsPrivateEndpointName: storageAccountDfsPrivateEndpointName
    dfsPrivateEndpointIP: storageAccountDfsPrivateEndpointIP
    dfsPrivateEndpointNicName: storageDfsPeNicName
    blobContainers: blobContainers
    subnetId: peVnet::peSubnet.id
  }
}

output storageAccountName string = storage.outputs.name
output storageAccountResourceId string = storage.outputs.resourceId
output storageAccountSystemAssignedIdentityPrincipalId string = storage.outputs.systemAssignedIdentityPrincipalId
output storageAccountUserAssignedIdentityResourceId string = storage.outputs.userAssignedIdentityResourceId
output storageAccountUserAssignedIdentityPrincipalId string = storage.outputs.userAssignedIdentityPrincipalId
output keyVaultName string = kv.outputs.name
output keyVaultResourceId string = kv.outputs.resourceId
