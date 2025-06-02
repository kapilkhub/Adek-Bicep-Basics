using 'azure-architect.bicep'

param environmentName = 'production'

param appsettings = {
  awesomeFeatureCount:3
  awesomeFeatureDisplayName:'turn everything gray'
  enableAwesomeFeature:false
  startStop: 'START'
}
