  @allowed(['development','testing','staging','production'])
 param environmentName string

import {websiteSettings} from 'modules/appservice.bicep'

param websiteSettingConfig websiteSettings

module appServiceModule 'br/fakecom:bicep/modules/appservice:v1'= {
  name: 'appServiceModule'
  params: {
    appsettings: websiteSettingConfig
    environmentName: environmentName
  }
}
 

module applicationInsightsModule 'br/fakecom:bicep/modules/applicationinsights:v1'= {
  name: 'appInsightsDeployment'
  params: {
    environmentName: environmentName
    metricsPublisherPrincipalId: appServiceModule.outputs.websiteManagedIdentityPrincipalId
  }
}



module sqlDatabaseModule 'br/fakecom:bicep/modules/sqldatabase:v1' = {
  name: 'sqlDatabaseDeployment'
  params: {
    administratorManagedIdentityClientIdentity: appServiceModule.outputs.websiteManagedIdentityClientId 
    administratorManagedIdentityName: appServiceModule.outputs.websiteManagedIdentityName
    environmentName:  environmentName
  }
}


