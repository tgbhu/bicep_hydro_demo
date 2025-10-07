// === Paraméterek ===
// A modul ezeket a bemeneti értékeket várja a hívó féltől (pl. main.bicep).
@description('Az erőforrás nevének előtagja.')
param namePrefix string

@description('Az Azure régió.')
param location string


// === Változó ===
// A Storage Account nevének globálisan egyedinek kell lennie és csak kisbetűket tartalmazhat.
var storageAccountName = toLower('${namePrefix}st${uniqueString(resourceGroup().id)}')


// === Erőforrás ===
// A Storage Account erőforrás definíciója.
resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}


// === Kimenet ===
// A modul visszaadja a létrehozott Storage Account nevét.
// Ezt az értéket fogja felhasználni a main.bicep.
@description('A létrehozott Storage Account neve.')
output storageAccountName string = storageAccount.name
