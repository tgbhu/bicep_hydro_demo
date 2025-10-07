
// === Paraméterek ===
@description('Az erőforrás nevének előtagja.')
param namePrefix string

@description('Az Azure régió.')
param location string

@description('A kapcsolódó Storage Account neve. Ezt az értéket a Web App beállításaiban tároljuk el.')
param storageAccountName string


// === Változók ===
// A nevek konzisztens képzése a változók segítségével.
var appServicePlanName = toLower('asp-${namePrefix}')
var webAppName = toLower('app-${namePrefix}-${uniqueString(resourceGroup().id)}')


// === Erőforrások ===

// 1. Az App Service Plan, ami a "motorja" a webalkalmazásnak.
resource appServicePlan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'F1' // Ingyenes, fejlesztői tier
    capacity: 1
  }
}

// 2. A Web App (App Service) erőforrás.
resource webApp 'Microsoft.Web/sites@2024-11-01' = {
  name: webAppName
  location: location
  properties: {
    // Implicit függőség: a web app hivatkozik az app service plan-re.
    serverFarmId: appServicePlan.id
    httpsOnly: true

    // Az alkalmazásbeállítások (app settings) megadása.
    siteConfig: {
      appSettings: [
        {
          name: 'StorageAccountName' // A beállítás kulcsa
          value: storageAccountName   // A beállítás értéke, amit paraméterként kaptunk
        }
      ]
    }
  }
}


// === Kimenet ===
// Visszaadjuk a létrehozott webalkalmazás URL-jét.
@description('A létrehozott webalkalmazás alapértelmezett hosztneve.')
output hostname string = webApp.properties.defaultHostName
