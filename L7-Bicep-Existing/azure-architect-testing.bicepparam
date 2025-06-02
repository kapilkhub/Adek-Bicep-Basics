using 'azure-architect.bicep'


param environmentName = 'testing'

param appsettings = {
  awesomeFeatureCount:3
  awesomeFeatureDisplayName:'turn everything blue'
  enableAwesomeFeature:false
  startStop: 'STOP'
}
