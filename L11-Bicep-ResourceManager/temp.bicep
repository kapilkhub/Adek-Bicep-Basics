resource fakecompanysqlserver_testing 'Microsoft.Sql/servers@2022-02-01-preview' = {
  kind: 'v12.0'
  properties: {
    administratorLogin: 'CloudSA068ba156'
    version: '12.0'
    state: 'Ready'
    fullyQualifiedDomainName: 'fakecompanysqlserver-testing.database.windows.net'
    privateEndpointConnections: []
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'Group'
      login: 'websiteManagedIdentity'
      sid: '71f7b980-a2f1-419d-a6e4-4607b7f94ec1'
      tenantId: '271647f2-be74-4390-aed2-e8b58cab5050'
      azureADOnlyAuthentication: true
    }
    restrictOutboundNetworkAccess: 'Disabled'
  }
  location: 'uaenorth'
  name: 'fakecompanysqlserver-testing'
}
