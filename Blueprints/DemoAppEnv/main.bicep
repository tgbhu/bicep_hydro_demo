// === Paraméterek ===
// Ezek a globális paraméterek, amelyeket a teljes telepítéshez használunk.
@description('Az erőforrások nevének előtagja, a konzisztens elnevezésért.')
param namePrefix string = 'bicepwebapp'

@description('Az Azure régió, ahová az összes erőforrás települ.')
param location string = resourceGroup().location


// === Modulok ===
// A modulok segítségével bontjuk logikai egységekre az infrastruktúrát.

// 1. Storage modul meghívása
// Ez a lépés létrehozza a Storage Accountot a saját, dedikált moduljával.
module storageModule '../../Bricks/Storage/main.bicep' = {
  // A 'name' a deployment nevét adja az Azure-ban a jobb követhetőségért.
  name: 'StorageDeployment'
  // A 'params' szekcióban adjuk át a szükséges bemeneti értékeket a modulnak.
  params: {
    namePrefix: namePrefix
    location: location
  }
}

// 2. App Service modul meghívása
// Miután a storage modul sikeresen lefutott, meghívjuk az app service modult.
module appServiceModule '../../Bricks/AppService/main.bicep' = {
  name: 'AppServiceDeployment'
  params: {
    namePrefix: namePrefix
    location: location

    // === ADATKAPCSOLAT ===
    // Itt történik a varázslat: a storage modul kimenetét (outputs)
    // közvetlenül bekötjük az app service modul bemenetére (params).
    // A Bicep ebből automatikusan tudja, hogy meg kell várnia a storageModule befejezését.
    storageAccountName: storageModule.outputs.storageAccountName
  }
}


// === Kimenetek ===
// A legfelső szintű kimenet a felhasználó számára legfontosabb információ,
// ebben az esetben a létrehozott webalkalmazás elérési útja.
@description('A létrehozott webalkalmazás alapértelmezett hosztneve.')
output webAppUrl string = appServiceModule.outputs.hostname
