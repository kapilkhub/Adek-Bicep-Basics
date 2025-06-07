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
 
module applicationInsightsModule2 'ts/fakecompany:applicationinsights:1.0'= {
  name: 'appInsightsDeployment'
  params: {
    environmentName: environmentName
    metricsPublisherPrincipalId: appServiceModule.outputs.websiteManagedIdentityPrincipalId
  }
}




module sqlDatabaseModule 'ts/fakecompany:sqldatabase:1.0' = {
  name: 'sqlDatabaseDeployment'
  params: {
    administratorManagedIdentityClientIdentity: appServiceModule.outputs.websiteManagedIdentityClientId 
    administratorManagedIdentityName: appServiceModule.outputs.websiteManagedIdentityName
    environmentName:  environmentName
  }
}


