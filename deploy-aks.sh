
#!/bin/sh
docker context use default
docker load --input davidsauthtestcg8zajs7-main.image

docker build -t davidsauthtestcg8zajs7-main-vault ./vault

echo "Resource group name:"
read resource_group
echo "Azure Container Registry instance name:"
read acr_name
echo "Logging in to Azure Container Registry instance..."
az acr login --name $acr_name

echo "azure_acr=$acr_name.azurecr.io" >> .env

echo "Tagging and pushing image to acr"
docker tag davidsauthtestcg8zajs7-main $acr_name.azurecr.io/davidsauthtestcg8zajs7-main
docker tag davidsauthtestcg8zajs7-main-vault $acr_name.azurecr.io/davidsauthtestcg8zajs7-main-vault

docker push $acr_name.azurecr.io/davidsauthtestcg8zajs7-main
docker push $acr_name.azurecr.io/davidsauthtestcg8zajs7-main-vault

echo "AKS cluster name:"
read aks_cluster

export $(cat .env | xargs)

envsubst < vault-manifest.yml > vault-manifest-replaced.yml

az aks get-credentials -g $resource_group --name $aks_cluster

kubectl apply -f vault-manifest-replaced.yml

sleep 10s

IP=($(exec kubectl get service/$uiflow_image -o jsonpath='{.status.loadBalancer.ingress[0].ip}'))

az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$IP')].[dnsSettings.fqdn]" -o tsv
