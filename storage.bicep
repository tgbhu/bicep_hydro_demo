param tags object


// A modul által generált címkéket felhasználjuk egy erőforráson.
resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'sttagged${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
  // Use a parameter or a variable for tags, as module outputs are not allowed here
  tags: tags
}
