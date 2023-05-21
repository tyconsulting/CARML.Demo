# CARML Demo Bicep Template

This template deploys the following resources:

* Key Vault for Custom Managed Key Encryption
  * Private Endpoint for the Key Vault
  * a CMK Key for the storage account
* Storage Account
  * Private Endpoints for the Storage Account Blob and DFS (Data Lake) services
* User Assigned Managed Identity for the Storage account CMK encryption

## Template Deployment

```powershell
#Subscription and Resource Group
$subscription = 'The-Big-MVP-Sub-2'
$resourceGroup = 'rg-ae-p-clz-deployment-test-001'

#deploy
Set-AzContext -Subscription $subscription
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -TemplateFile .\demo\main.bicep -TemplateParameterFile .\demo\main.parameters.json -verbose
```