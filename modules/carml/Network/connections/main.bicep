@description('Required. Remote connection name.')
param name string

@description('Optional. Specifies a VPN shared key. The same value has to be specified on both Virtual Network Gateways.')
param vpnSharedKey string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Gateway connection connectionType.')
@allowed([
  'IPsec'
  'Vnet2Vnet'
  'ExpressRoute'
  'VPNClient'
])
param connectionType string = 'IPsec'

@description('Optional. Value to specify if BGP is enabled or not.')
param enableBgp bool = false

@allowed([
  'Default'
  'InitiatorOnly'
  'ResponderOnly'
])
@description('Optional. The connection connectionMode for this connection. Available for IPSec connections.')
param connectionMode string = 'Default'

@allowed([
  'IKEv1'
  'IKEv2'
])
@description('Optional. Connection connectionProtocol used for this connection. Available for IPSec connections.')
param connectionProtocol string = 'IKEv2'

@minValue(9)
@maxValue(3600)
@description('Optional. The dead peer detection timeout of this connection in seconds. Setting the timeout to shorter periods will cause IKE to rekey more aggressively, causing the connection to appear to be disconnected in some instances. The general recommendation is to set the timeout between 30 to 45 seconds.')
param dpdTimeoutSeconds int = 45

@description('Optional. Enable policy-based traffic selectors.')
param usePolicyBasedTrafficSelectors bool = false

@description('Optional. Bypass the ExpressRoute gateway when accessing private-links. ExpressRoute FastPath (expressRouteGatewayBypass) must be enabled. Only available when connection connectionType is Express Route.')
param enablePrivateLinkFastPath bool = false

@description('Optional. Bypass ExpressRoute Gateway for data forwarding. Only available when connection connectionType is Express Route.')
param expressRouteGatewayBypass bool = false

@description('Optional. Use private local Azure IP for the connection. Only available for IPSec Virtual Network Gateways that use the Azure Private IP Property.')
param useLocalAzureIpAddress bool = false

@description('Optional. The IPSec Policies to be considered by this connection.')
param customIPSecPolicy object = {
  saLifeTimeSeconds: 0
  saDataSizeKilobytes: 0
  ipsecEncryption: ''
  ipsecIntegrity: ''
  ikeEncryption: ''
  ikeIntegrity: ''
  dhGroup: ''
  pfsGroup: ''
}

@description('Optional. The weight added to routes learned from this BGP speaker.')
param routingWeight int = -1

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the connectionType of lock.')
param lock string = ''

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Required. The primary Virtual Network Gateway.')
param virtualNetworkGateway1 object

@description('Optional. The remote Virtual Network Gateway. Used for connection connectionType [Vnet2Vnet].')
param virtualNetworkGateway2 object = {}

@description('Optional. The remote peer. Used for connection connectionType [ExpressRoute].')
param peer object = {}

@description('Optional. The Authorization Key to connect to an Express Route Circuit. Used for connection type [ExpressRoute].')
@secure()
param authorizationKey string = ''

@description('Optional. The local network gateway. Used for connection type [IPsec].')
param localNetworkGateway2 object = {}

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource connection 'Microsoft.Network/connections@2022-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    connectionType: connectionType
    connectionMode: connectionType == 'IPsec' ? connectionMode : null
    connectionProtocol: connectionType == 'IPsec' ? connectionProtocol : null
    dpdTimeoutSeconds: connectionType == 'IPsec' ? dpdTimeoutSeconds : null
    enablePrivateLinkFastPath: connectionType == 'ExpressRoute' ? enablePrivateLinkFastPath : null
    expressRouteGatewayBypass: connectionType == 'ExpressRoute' ? expressRouteGatewayBypass : null
    virtualNetworkGateway1: virtualNetworkGateway1
    virtualNetworkGateway2: connectionType == 'Vnet2Vnet' ? virtualNetworkGateway2 : null
    localNetworkGateway2: connectionType == 'IPsec' ? localNetworkGateway2 : null
    peer: connectionType == 'ExpressRoute' ? peer : null
    authorizationKey: connectionType == 'ExpressRoute' && !empty(authorizationKey) ? authorizationKey : null
    sharedKey: connectionType != 'ExpressRoute' ? vpnSharedKey : null
    usePolicyBasedTrafficSelectors: usePolicyBasedTrafficSelectors
    ipsecPolicies: !empty(customIPSecPolicy.ipsecEncryption) ? [
      {
        saLifeTimeSeconds: customIPSecPolicy.saLifeTimeSeconds
        saDataSizeKilobytes: customIPSecPolicy.saDataSizeKilobytes
        ipsecEncryption: customIPSecPolicy.ipsecEncryption
        ipsecIntegrity: customIPSecPolicy.ipsecIntegrity
        ikeEncryption: customIPSecPolicy.ikeEncryption
        ikeIntegrity: customIPSecPolicy.ikeIntegrity
        dhGroup: customIPSecPolicy.dhGroup
        pfsGroup: customIPSecPolicy.pfsGroup
      }
    ] : customIPSecPolicy.ipsecEncryption
    routingWeight: routingWeight != -1 ? routingWeight : null
    enableBgp: enableBgp
    useLocalAzureIpAddress: connectionType == 'IPsec' ? useLocalAzureIpAddress : null
  }
}

resource connection_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${connection.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: connection
}

@description('The resource group the remote connection was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the remote connection.')
output name string = connection.name

@description('The resource ID of the remote connection.')
output resourceId string = connection.id

@description('The location the resource was deployed into.')
output location string = connection.location
