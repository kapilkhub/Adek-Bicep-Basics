resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: 'fakeAppServicePlan'
  location: resourceGroup().location
  sku: {
    name: 'B1'
  }
  
}

resource webApp 'Microsoft.Web/sites@2024-11-01' = {
  name: 'fakeWebApp'
  location: resourceGroup().location
  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource webappsettings 'Microsoft.Web/sites/config@2024-11-01'= {
  name: 'appsettings'
  parent: webApp
  properties:{
    enableAwesomeFeature: 'true'
  } 
}
