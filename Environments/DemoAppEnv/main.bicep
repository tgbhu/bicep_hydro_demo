@description('Az erőforrások nevének előtagja, a konzisztens elnevezésért.')
param namePrefix string = 'bicepwebapp'

@description('Az Azure régió, ahová az összes erőforrás települ.')
param location string = resourceGroup().location


module demoapp '../../Blueprints/DemoAppEnv/main.bicep' = {
  name: 'DemoAppEnvDeployment'
  params: {
    namePrefix: namePrefix
    location: location
  }
}

@description('A létrehozott webalkalmazás alapértelmezett hosztneve.')
output webAppUrl string = demoapp.outputs.webAppUrl
