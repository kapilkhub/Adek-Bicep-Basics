using 'azure-architect.bicep'

param environmentName = 'production'

param websiteSettingConfig = {
  awesomeFeatureCount: 4
  awesomeFeatureDisplayName: 'purple' 
  enableAwesomeFeature: true
  startStop:  'START'
}
