param environment string = 'dev'

// A modul hivatkozás már nem egy helyi fájlra, hanem a registry-re mutat.
// A Bicep a telepítés során innen fogja letölteni a v1.0.0 verziót.
module tagsModule 'br:bicephydro.azurecr.io/bicep/standard-tags:v1.0.0' = {
  name: 'GetStandardTags'
  params: {
    environment: environment
  }
}


module storageModule 'modules/storage.bicep' = {
  name: 'DeployStorage'
  params: {
    tags: tagsModule.outputs.standardTags
  }
}

