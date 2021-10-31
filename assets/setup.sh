export rg='ignite-demo'
export log_workspace='logs-env-vjhepqwyh42cw'
export environment='env-vjhepqwyh42cw'
export pass='0ba8e36ae72238402bf52cf5a9a9f84d32c39e74'
export dotnetImage='ghcr.io/jeffhollan/container-app-demo/dotnet-service@sha256:d6cd2d8668483298c3c87a30ea1f78ab2723b6de0c3a63f488012e1492e3a675'
export pythonImage='ghcr.io/jeffhollan/container-app-demo/python-service@sha256:4442265a3d73289311ad4fd5e0e5a30d54c27aef96df1eb34ab3b57136e29c67'
export goImage='ghcr.io/jeffhollan/container-app-demo/go-service@sha256:75e5ad245426890ec095b4eb2a03b13c382b8269b779ef5ef0f0a7828101d4dd'

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
      dotnetImage=$dotnetImage \
      dotnetPort=80 \
      isDotnetExternalIngress=true \
      pythonImage=$pythonImage \
      pythonPort=5000 \
      isPythonExternalIngress=true \
      goImage=$goImage \
      goPort=8050 \
      isGoExternalIngress=true \
      containerRegistry=ghcr.io \
      containerRegistryUsername=jeffhollan \
      containerRegistryPassword=$pass

# export ORDER_SERVICE_NAME=python-app && dapr run --app-id dotnet-app --app-port 5157 -- dotnet run
# dapr run --app-id python-app --app-port 5000 -d . -- python app.py