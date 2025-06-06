  @allowed(['development','testing','staging','production'])
 param environmentName string

import {websiteSettings} from 'modules/appservice.bicep'

param websiteSettingConfig websiteSettings

module appServiceModule 'modules/appservice.bicep' = {
  name: 'appServiceModule'
  params: {
    appsettings: websiteSettingConfig
    environmentName: environmentName
  }
}



module applicationInsightsModule 'modules/applicationInsights.bicep'= {
  name: 'appInsightsDeployment'
  params: {
    environmentName: environmentName
    metricsPublisherPrincipalId: appServiceModule.outputs.websiteManagedIdentityPrincipalId
  }
}

module sqlDatabaseModule 'modules/sqlDatabase.bicep' = {
  name: 'sqlDatabaseDeployment'
  params: {
    administratorManagedIdentityClientIdentity: appServiceModule.outputs.websiteManagedIdentityClientId 
    administratorManagedIdentityName: appServiceModule.outputs.websiteManagedIdentityName
    environmentName:  environmentName
  }
}


