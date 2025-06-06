  @allowed(['development','testing','staging','production'])
 param environmentName string

 var responseTimeThreshold =3
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
      loganalytics.id
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
