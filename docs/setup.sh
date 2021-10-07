export rg='ignite-demo'
export log_workspace='logs-env-vjhepqwyh42cw'
export environment='env-vjhepqwyh42cw'
export pass='0ba8e36ae72238402bf52cf5a9a9f84d32c39e74'
export dotnetImage='ghcr.io/jeffhollan/container-app-demo/dotnet-service@sha256:39b82775605b5f4bc67b6ccfa7e4b3e7035b8ba73941b4d7281ad0ce0843e3a5'
export pythonImage='ghcr.io/jeffhollan/container-app-demo/python-service:main'
export goImage='ghcr.io/jeffhollan/container-app-demo/go-service:main'

# az cloud set --name CloudWithCustomEndpoint

# az group create -n $rg --location 'northcentralus'

# az monitor log-analytics workspace create -g $rg -n $log_workspace
# export log_clientid=`az monitor log-analytics workspace show --query customerId -g $rg -n $log_workspace --out json | tr -d '"'`
# export log_secret=`az monitor log-analytics workspace get-shared-keys --query primarySharedKey -g $rg -n $log_workspace --out json | tr -d '"'`

# az containerapp env create -n $environment -g $rg --logs-workspace-id $log_clientid --logs-workspace-key $log_secret --location "North Central US (Stage)" --debug

# az containerapp create -n dotnet-app -g $rg --environment $environment --image ghcr.io/jeffhollan/dotnet-service:main --target-port 80 --ingress 'external' -l "North Central US (Stage)" --debug



# az containerapp create -n dotnet-app -g $rg --image $dotnetImage --environment $environment --cpu 0.5 --memory '500Mi'  --dapr-app-port 80 --enable-dapr --ingress 'external' --target-port 80 --min-replicas 1 --registry-username jeffhollan --registry-login-server 'ghcr.io' --registry-password $pass -v ORDER_SERVICE_NAME=python-app;INVENTORY_SERVICE_NAME=go-app --debug
# az containerapp create -n python-app -g $rg --image $pythonImage --environment $environment --cpu 0.5 --memory '500Mi'  --dapr-app-port 5000 --dapr-app-id python-app --enable-dapr --ingress 'external' --target-port 5000 --min-replicas 1 --registry-username jeffhollan --registry-login-server 'ghcr.io' --registry-password $pass -v FOO=bar --revisions-mode 'multiple' --debug
# az containerapp create -n go-app -g $rg --image $goImage --environment $environment --cpu 0.5 --memory '500Mi'  --dapr-app-port 8050 --enable-dapr --ingress 'external' --target-port 8050 --min-replicas 1 --registry-username jeffhollan --registry-login-server 'ghcr.io' --registry-password $pass -v FOO=bar

az deployment group create -g $rg -f ./deploy/main.bicep \
   -p \
      dotnetImage='ghcr.io/jeffhollan/container-app-demo/dotnet-service@sha256:16f335211261cca9f97d69b93aea03b5c84f84e57d01db7edf6ab950e2c97e11' \
      dotnetPort=80 \
      isDotnetExternalIngress=true \
      pythonImage='ghcr.io/jeffhollan/container-app-demo/python-service@sha256:c001b8bc9b99b2cde5195a7bbf19ecc5d8438f36ef941b387bf35d17bc3bcd9c' \
      pythonPort=5000 \
      isPythonExternalIngress=false \
      goImage='ghcr.io/jeffhollan/container-app-demo/go-service@sha256:5e546e6505019c5b2c8ad2e845350761ea61c069f93b17d5284a367e288fd485' \
      goPort=8050 \
      isGoExternalIngress=false \
      containerRegistry=ghcr.io \
      containerRegistryUsername=jeffhollan \
      containerRegistryPassword=$pass