# Container App Demo

Simple microservices solution of a Store API backed by 2 microservices for orders and inventory.

![architecture](./docs/arch.png)

The Store API is a minimal API written in Node 14 (Express.js).  The orders service is a Python Flask app backed by Cosmos DB.  The inventory service is a Go app.

Dapr brokers service-to-service communication, and integrates with state store for added flexibility.

### Local debug

`dapr run --app-id go-app --app-port 8050 -- go run .`
`dapr run --app-id python-app --app-port 5000 -- python app.py`
### Github Actions Secrets

| Name | Description |
|------|-------------|
| RESOURCE_GROUP | The resource group name |
| AZURE_CREDENTIALS | The Azure credentials in JSON format |

### If created with the CLI

#### Container Apps

`az workerapp create -n go-app -g $rg --image ghcr.io/jeffhollan/container-app-solution/go-app@sha256:bdee638cba84407888d71fffa19db984bd5114a5267885978e6276f6fd6b13fe --environment $env --cpu 0.2 --memory '500Mi' --dapr-app-id go-app --dapr-port 8050 --enable-dapr --ingress 'external' --target-port 8050 --min-replicas 1 --registry-username jeffhollan --registry-login-server 'ghcr.io' --registry-password $pass --debug`

`az workerapp create -n python-app -g $rg --image ghcr.io/jeffhollan/container-app-solution/python-app:main --environment $env --cpu 0.5 --memory '500Mi' --dapr-app-id python-app --dapr-port 5000 --enable-dapr --ingress 'external' --target-port 5000 --min-replicas 1 --registry-username jeffhollan --registry-login-server 'ghcr.io' --registry-password $pass --debug`

`az workerapp update -n python-app -g $rg --image ghcr.io/jeffhollan/container-app-solution/python-app:main -s ghcrio-jeffhollan=$pass --debug`