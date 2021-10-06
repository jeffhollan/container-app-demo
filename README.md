# Project Name

(short, 1-3 sentenced, description of the project)

## Features

This project framework provides the following features:

* Feature 1
* Feature 2
* ...

## Getting Started

### Prerequisites

(ideally very short, if any)

- OS
- Library version
- ...

### Installation

(ideally very short)

- npm install [package name]
- mvn install
- ...

### Quickstart
(Add steps to get up and running quickly)

1. git clone [repository clone url]
2. cd [respository name]
3. ...


## Demo

A demo app is included to show how to use the project.

To run the demo, follow these steps:

(Add steps to start up the demo)

1.
2.
3.

## Resources

(Any additional resources or related projects)

- Link to supporting information
- Link to similar sample
- ...


-----

# Container App solution

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