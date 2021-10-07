param environmentName string = 'env-${uniqueString(resourceGroup().id)}'
param dotnetImage string = 'nginx'
param dotnetPort int = 80
param isDotnetExternalIngress bool = true
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

var dotnetServiceAppName = 'dotnet-app'
var pythonServiceAppName = 'python-app'
var goServiceAppName = 'go-app'

// // container app environment
// module environment 'environment.bicep' = {
//   name: 'container-app-environment'
//   params: {
//     environmentName: environmentName
//   }
// }

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


// dotnet App
module dotnetService 'container-http.bicep' = {
  name: dotnetServiceAppName
  params: {
    containerAppName: dotnetServiceAppName
    location: 'northcentralusstage'
    environmentId: '/subscriptions/411a9cd0-f057-4ae5-8def-cc1ea96a3933/resourceGroups/ignite-demo/providers/Microsoft.Web/kubeEnvironments/env-vjhepqwyh42cw'
    containerImage: dotnetImage
    containerPort: dotnetPort
    isExternalIngress: isDotnetExternalIngress
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



output dotnetFqdn string = dotnetService.outputs.fqdn
output pythonFqdn string = pythonService.outputs.fqdn
output goFqdn string = goService.outputs.fqdn
