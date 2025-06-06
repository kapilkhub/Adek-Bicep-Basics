@allowed(['development','testing','staging','production'])
param environmentName string

param metricsPublisherPrincipalId string 

resource loganalyticsworkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = {
  name: 'fakecompanyLogAnalytics'
  scope: resourceGroup(subscription().subscriptionId,'fakeAnalyticsResourceGroup')
}

var metricPublisherWellKnownId = '3913510d-42f4-4e42-8a64-420c390055eb' //azure built in roles

resource meticsPublisherRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview'={
  name: metricPublisherWellKnownId
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'fakeWebApp-${environmentName}'
  location: 'uaenorth'
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: loganalyticsworkspace.id
  }
}

resource monitoringMetricsPublisherRoleId 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(applicationInsights.name,metricsPublisherPrincipalId,meticsPublisherRoleDefinition.id)
  scope: applicationInsights
  properties: {
    principalId: metricsPublisherPrincipalId
    roleDefinitionId: meticsPublisherRoleDefinition.id
  }
}
