export rg='ignite-demo'
export log_workspace='logs-env-vjhepqwyh42cw'
export environment='env-vjhepqwyh42cw'

az cloud set --name CloudWithCustomEndpoint

az group create -n $rg --location 'northcentralus'

az monitor log-analytics workspace create -g $rg -n $log_workspace
export log_clientid=`az monitor log-analytics workspace show --query customerId -g $rg -n $log_workspace --out json | tr -d '"'`
export log_secret=`az monitor log-analytics workspace get-shared-keys --query primarySharedKey -g $rg -n $log_workspace --out json | tr -d '"'`

az containerapp env create -n $environment -g $rg --logs-workspace-id $log_clientid --logs-workspace-key $log_secret --location "North Central US (Stage)" --debug

az containerapp create -n dotnet-app -g $rg --environment $environment --image ghcr.io/jeffhollan/dotnet-service:main --target-port 80 --ingress 'external' -l "North Central US (Stage)" --debug