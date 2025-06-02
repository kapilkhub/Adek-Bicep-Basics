  @allowed(['development','testing','staging','production'])
 param environmentName string

type websiteSettings = {
@description('Awesome feature count can only be between 3 and 5')
@minValue(3)
@maxValue(5)
awesomeFeatureCount: int

@description('awesome feature display name can only be min 3 characters and max 20 characters')
@minLength(3)
@maxLength(20)
awesomeFeatureDisplayName: string

@description('enable awesome feature?')
 enableAwesomeFeature: bool

startStop: 'START' | 'STOP'

}

param appsettings websiteSettings

var skuName = environmentName == 'production'? 'S1': 'B1'

resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: 'fakeAppServicePlan-${environmentName}'
  location: resourceGroup().location
  sku: {
    name: skuName
  }
  
}

var featureCountIsEven = appsettings.awesomeFeatureCount %2 == 0
var shouldEnableAwesomeFeature = featureCountIsEven && appsettings.enableAwesomeFeature

resource webApp 'Microsoft.Web/sites@2024-11-01' = {
  name: 'fakeWebApp-${environmentName}'
  location: resourceGroup().location
  properties: {
    serverFarmId: appServicePlan.id
  }
  
  resource webappsettings 'config@2024-11-01'= {
  name: 'appsettings'
  properties:{
    enableAwesomeFeature: string(shouldEnableAwesomeFeature)
    awesomeFeatureCount: string(appsettings.awesomeFeatureCount)
    awesomeFeatureDisplayName: string(appsettings.awesomeFeatureDisplayName)
  } 
}
}



