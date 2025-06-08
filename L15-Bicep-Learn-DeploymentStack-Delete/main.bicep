// Parameters
@description('The location for all resources.')
param location string = 'uaenorth'

@description('The name of the web application.')
param webApplicationName string = 'webapp-${uniqueString(resourceGroup().id)}'

// Variables


@description('The name of the app service plan.')
var appServicePlanName = 'plan-deposits'


// Resource - App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'S1'
    capacity: 1
  }
}

// Resource - Web App
resource webApplication 'Microsoft.Web/sites@2023-12-01' = {
  name: webApplicationName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
}
