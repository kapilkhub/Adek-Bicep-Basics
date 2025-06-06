  @allowed(['development','testing','staging','production'])
 param environmentName string

resource loganalyticsworkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = {
  name: 'fakecompanyLogAnalytics'
  scope: resourceGroup(subscription().subscriptionId,'fakeAnalyticsResourceGroup')
}

resource loganalytics 'Microsoft.Insights/components@2020-02-02' = {
  name: 'fakeWebApp-${environmentName}'
  location: 'uaenorth'
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: loganalyticsworkspace.id
  }
}
