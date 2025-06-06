  @allowed(['development','testing','staging','production'])
 param environmentName string

 param administratorManagedIdentityName string
 param administratorManagedIdentityClientIdentity string

resource sqlServer 'Microsoft.Sql/servers@2023-08-01' = {
  name: 'fakeCompanySqlServer-${environmentName}'
  location: resourceGroup().location
  properties:{
    administrators:{
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: true
      login: administratorManagedIdentityName
      sid:administratorManagedIdentityClientIdentity
      tenantId: subscription().tenantId
    }
  }

  resource sqlDatabase 'databases' = {
    name: 'fakeCompanyDatabase'
    location: resourceGroup().location
  }
  
}
