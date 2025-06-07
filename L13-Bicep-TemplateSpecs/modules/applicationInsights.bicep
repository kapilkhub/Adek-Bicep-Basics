  @allowed(['development','testing','staging','production'])
 param environmentName string

 param metricsPublisherPrincipalId string

resource loganalyticsworkspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = {
  name: 'fakecompanyLogAnalytics2'
  scope: resourceGroup(subscription().subscriptionId,'fakeCompany-sharedResources')
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

var wellKnownMetricsPublisherRoleId = '3913510d-42f4-4e42-8a64-420c390055eb'

resource metricsPublisherRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01'  existing = {
  name: wellKnownMetricsPublisherRoleId
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01'= {
  scope: applicationInsights
  name:  guid(applicationInsights.name, metricsPublisherPrincipalId, metricsPublisherRoleDefinition.id)
  properties: {
    principalId: metricsPublisherPrincipalId
    roleDefinitionId: metricsPublisherRoleDefinition.id
  }
}

var matricDetails= [{
  metricName: 'Rule for slow requests'
  responseTimeThreshold: 3
},{

  metricName: 'Rule for extremely slow requests'
  responseTimeThreshold: 3
}]


resource metricAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = [for metric in matricDetails: if(environmentName == 'production') {
  name: metric.metricName
  location: 'global'
  properties: {
    description: 'Response time alert'
    severity: 0
    enabled: true
    scopes: [
      applicationInsights.id
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: '1st criterion'
          metricName: 'requests/duration'
          operator: 'GreaterThan'
          threshold: metric.responseTimeThreshold
          timeAggregation: 'Average'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
    }
    actions: [
      {
        actionGroupId: emailActionGroup.id
      }
    ]
  }
}]

resource emailActionGroup 'microsoft.insights/actionGroups@2019-06-01' = {
  name: 'emailActionGroup'
  location: 'global'
  properties: {
    groupShortName: 'string'
    enabled: true
    emailReceivers: [
      {
        name: 'Example'
        emailAddress: 'example@test.com'
        useCommonAlertSchema: true
      }
    ]
  }
}


