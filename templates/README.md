# CARML Demo Bicep Template

## Template Deployment

```powershell
#Subscription and Resource Group
$subscription = 'The-Big-MVP-Sub-2'
$resourceGroup = 'rg-ae-p-clz-deployment-test-001'

#deploy
Set-AzContext -Subscription $subscription
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroup -TemplateFile .\demo\main.bicep -TemplateParameterFile .\demo\main.parameters.json -verbose
```