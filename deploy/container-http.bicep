param containerAppName string
param location string
param environmentId string
param containerImage string
param containerPort int
param isExternalIngress bool
param containerRegistry string
param containerRegistryUsername string
param env array = []

@allowed([
  'multiple'
  'single'
])
param revisionMode string = 'single'

@secure()
param containerRegistryPassword string

var cpu = json('0.5')
var memory = '500Mi'
var registrySecretRefName = 'docker-password'

resource containerApp 'Microsoft.Web/workerApps@2021-02-01' = {
  name: containerAppName
  kind: 'workerapp'
  location: location
  properties: {
    kubeEnvironmentId: environmentId
    configuration: {
      activeRevisionsMode: revisionMode
      secrets: [
        {
          name: registrySecretRefName
          value: containerRegistryPassword
        }
      ]
      registries: [
        {
          server: containerRegistry
          username: containerRegistryUsername
          passwordSecretRef: registrySecretRefName
        }
      ]
      ingress: {
        external: isExternalIngress
        targetPort: containerPort
        transport: 'auto'
        // traffic: [
        //   {
        //     weight: 100
        //     latestRevision: true
        //   }
        // ]
      }
    }
    template: {
      containers: [
        {
          image: containerImage
          name: containerAppName
          env: env
          resources: {
            cpu: cpu
            memory: memory
          }
        }
      ]
      scale: {
        minReplicas: 1
        maxReplicas: 10
      //   rules: [{
      //     name: 'httpscale'
      //     http: {
      //       metadata: {
      //         concurrentRequests: 100
      //       }
      //     }
      //   }
      //   ]
      }
      // dapr: {
      //   enabled: true
      //   appPort: containerPort
      //   appId: containerAppName
      // }
    }
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn
