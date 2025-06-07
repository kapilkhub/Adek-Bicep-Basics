using 'azure-architect.bicep'


param environmentName = 'testing'

param websiteSettingConfig = {
  awesomeFeatureCount: 3
  awesomeFeatureDisplayName: 'blue' 
  enableAwesomeFeature: false
  startStop:  'STOP'
}
