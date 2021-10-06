param environmentName string = 'env-${uniqueString(resourceGroup().id)}'
param pythonImage string = 'nginx'
param pythonPort int = 5000
param isPythonExternalIngress bool = false
param goImage string = 'nginx'
param goPort int = 8050
param isGoExternalIngress bool = true
param containerRegistry string
param containerRegistryUsername string

@secure()
param containerRegistryPassword string

var pythonServiceAppName = 'python-app'
var goServiceAppName = 'go-app'

// container app environment
module environment 'environment.bicep' = {
  name: 'container-app-environment'
  params: {
    environmentName: environmentName
  }
}

// Python App
module pythonService 'container-http.bicep' = {
  name: pythonServiceAppName
  params: {
    containerAppName: pythonServiceAppName
    location: environment.outputs.location
    environmentId: environment.outputs.environmentId
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
    location: environment.outputs.location
    environmentId: environment.outputs.environmentId
    containerImage: goImage
    containerPort: goPort
    isExternalIngress: isGoExternalIngress
    containerRegistry: containerRegistry
    containerRegistryUsername: containerRegistryUsername
    containerRegistryPassword: containerRegistryPassword
    env: [
      {
        name: 'PYTHON_APP_FQDN'
        value: pythonService.outputs.fqdn
      }
    ]
  }
}

output pythonFqdn string = pythonService.outputs.fqdn
output goFqdn string = goService.outputs.fqdn
