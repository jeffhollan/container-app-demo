export rg='ignite-demo'
export log_workspace='logs-env-vjhepqwyh42cw'
export environment='env-vjhepqwyh42cw'
export pass='0ba8e36ae72238402bf52cf5a9a9f84d32c39e74'
export dotnetImage='ghcr.io/jeffhollan/container-app-demo/dotnet-service:main'
export pythonImage='ghcr.io/jeffhollan/container-app-demo/python-service:main'
export goImage='ghcr.io/jeffhollan/container-app-demo/go-service:main'

# az cloud set --name CloudWithCustomEndpoint

# az group create -n $rg --location 'northcentralus'

# az monitor log-analytics workspace create -g $rg -n $log_workspace
# export log_clientid=`az monitor log-analytics workspace show --query customerId -g $rg -n $log_workspace --out json | tr -d '"'`
# export log_secret=`az monitor log-analytics workspace get-shared-keys --query primarySharedKey -g $rg -n $log_workspace --out json | tr -d '"'`

# az containerapp env create -n $environment -g $rg --logs-workspace-id $log_clientid --logs-workspace-key $log_secret --location "North Central US (Stage)" --debug

# az containerapp create -n dotnet-app -g $rg --environment $environment --image ghcr.io/jeffhollan/dotnet-service:main --target-port 80 --ingress 'external' -l "North Central US (Stage)" --debug



az containerapp create -n dotnet-app -g $rg --image $dotnetImage --environment $environment --cpu 0.5 --memory '500Mi'  --dapr-app-port 80 --enable-dapr --ingress 'external' --target-port 80 --min-replicas 1 --registry-username jeffhollan --registry-login-server 'ghcr.io' --registry-password $pass -v ORDER_SERVICE_NAME=python-app;INVENTORY_SERVICE_NAME=go-app --debug
az containerapp create -n python-app -g $rg --image $pythonImage --environment $environment --cpu 0.5 --memory '500Mi'  --dapr-app-port 5000 --dapr-app-id python-app --enable-dapr --ingress 'external' --target-port 5000 --min-replicas 1 --registry-username jeffhollan --registry-login-server 'ghcr.io' --registry-password $pass -v FOO=bar --revisions-mode 'multiple' --debug
az containerapp create -n go-app -g $rg --image $goImage --environment $environment --cpu 0.5 --memory '500Mi'  --dapr-app-port 8050 --enable-dapr --ingress 'external' --target-port 8050 --min-replicas 1 --registry-username jeffhollan --registry-login-server 'ghcr.io' --registry-password $pass -v FOO=bar
