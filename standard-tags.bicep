@description('A telepítési környezet neve (pl. dev, prod).')
param environment string

@description('A projekt vagy alkalmazás tulajdonosa.')
param owner string = 'Team-Phoenix'

param lastDeployed string = utcNow('yyyy-MM-ddTHH:mm:ssZ')

// A kimenet egy objektum, ami tartalmazza az összes szabványos címkét.
output standardTags object = {
  Environment: environment
  Owner: owner
  ManagedBy: 'Bicep'
  LastDeployed: lastDeployed// Dinamikusan beszúrja az aktuális dátumot
}
