  @allowed(['development','testing','staging','production'])
 param environmentName string

resource loganalyticsworkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = {
  name: 'fakecompanyLogAnalytics'
  scope: resourceGroup('fakeAnalyticsResourceGroup', subscription().id)
}

resource loganalytics 'Microsoft.Insights/components@2020-02-02' = {
  name: 'fakeWebApp-${environmentName}'
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId:loganalyticsworkspace.id
  }
}
