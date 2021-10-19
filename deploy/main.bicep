param environmentName string = 'env-${uniqueString(resourceGroup().id)}'
param nodeImage string = 'nginx'
param nodePort int = 3000
param isNodeExternalIngress bool = true
param pythonImage string = 'nginx'
param pythonPort int = 5000
param isPythonExternalIngress bool = false
param goImage string = 'nginx'
param goPort int = 8050
param isGoExternalIngress bool = false
param containerRegistry string
param containerRegistryUsername string

@secure()
param containerRegistryPassword string

var nodeServiceAppName = 'node-app'
var pythonServiceAppName = 'python-app'
var goServiceAppName = 'go-app'

// // container app environment
module environment 'environment.bicep' = {
  name: 'container-app-environment'
  params: {
    environmentName: environmentName
  }
}

// create cosmosdb
module cosmosdb 'cosmosdb.bicep' = {
  name: 'cosmosdb'
  params: {
    
  }
}

// Python App
module pythonService 'container-http.bicep' = {
  name: pythonServiceAppName
  params: {
    containerAppName: pythonServiceAppName
    location: 'northcentralusstage'
    environmentId: '/subscriptions/411a9cd0-f057-4ae5-8def-cc1ea96a3933/resourceGroups/ignite-demo/providers/Microsoft.Web/kubeEnvironments/env-vjhepqwyh42cw'
    containerImage: pythonImage
    containerPort: pythonPort
    isExternalIngress: isPythonExternalIngress
    containerRegistry: containerRegistry
    containerRegistryUsername: containerRegistryUsername
    containerRegistryPassword: containerRegistryPassword
    daprComponents: [
      {
        name: 'orders'
        type: 'state.azure.cosmosdb'
        version: 'v1'
        metadata: [
          {
            name: 'url'
            value: cosmosdb.outputs.documentEndpoint
          }
          {
            name: 'database'
            value: 'ordersDb'
          }
          {
            name: 'collection'
            value: 'orders'
          }
          {
            name: 'masterkey'
            secretRef: 'masterkey'
          }
        ]
      }
    ]
    secrets: [
      {
        name: 'docker-password'
        value: containerRegistryPassword
      }
      {
        name: 'masterkey'
        value: cosmosdb.outputs.primaryMasterKey
      }
    ]
  }
}


// Go App
module goService 'container-http.bicep' = {
  name: goServiceAppName
  params: {
    containerAppName: goServiceAppName
    location: 'northcentralusstage'
    environmentId: '/subscriptions/411a9cd0-f057-4ae5-8def-cc1ea96a3933/resourceGroups/ignite-demo/providers/Microsoft.Web/kubeEnvironments/env-vjhepqwyh42cw'
    containerImage: goImage
    containerPort: goPort
    isExternalIngress: isGoExternalIngress
    containerRegistry: containerRegistry
    containerRegistryUsername: containerRegistryUsername
    containerRegistryPassword: containerRegistryPassword
  }
}


// node App
module nodeService 'container-http.bicep' = {
  name: nodeServiceAppName
  params: {
    containerAppName: nodeServiceAppName
    location: 'northcentralusstage'
    environmentId: '/subscriptions/411a9cd0-f057-4ae5-8def-cc1ea96a3933/resourceGroups/ignite-demo/providers/Microsoft.Web/kubeEnvironments/env-vjhepqwyh42cw'
    containerImage: nodeImage
    containerPort: nodePort
    isExternalIngress: isNodeExternalIngress
    containerRegistry: containerRegistry
    containerRegistryUsername: containerRegistryUsername
    containerRegistryPassword: containerRegistryPassword
    env: [
      {
        name: 'ORDER_SERVICE_NAME'
        value: pythonServiceAppName
      }
      {
        name: 'INVENTORY_SERVICE_NAME'
        value: goServiceAppName
      }
    ]
  }
}



output nodeFqdn string = nodeService.outputs.fqdn
output pythonFqdn string = pythonService.outputs.fqdn
output goFqdn string = goService.outputs.fqdn
