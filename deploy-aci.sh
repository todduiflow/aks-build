
#!/bin/sh
docker context use default
docker load --input davidsauthtestcg8zajs7-main.image

echo "Add images to local registry"
docker compose -f docker-compose.local.yml up -d
docker compose -f docker-compose.local.yml down

echo "Choose resource group name:"
read resource_group
az group create --name $resource_group --location eastus

echo "Choose Azure Container Registry instance name:"
read acr_name
az acr create --resource-group $resource_group --name $acr_name --sku Basic

echo "Logging in to Azure Container Registry instance..."
az acr login --name $acr_name

echo "azure_acr=$acr_name.azurecr.io" >> .env

echo "Tagging and pushing image to acr"
docker tag davidsauthtestcg8zajs7-main $acr_name.azurecr.io/davidsauthtestcg8zajs7-main
docker tag davidsauthtestcg8zajs7-main-vault $acr_name.azurecr.io/davidsauthtestcg8zajs7-main-vault

docker push $acr_name.azurecr.io/davidsauthtestcg8zajs7-main
docker push $acr_name.azurecr.io/davidsauthtestcg8zajs7-main-vault

echo "Logging in to Azure..."
docker login azure

echo "Choose Azure Container Instances context name:"
read docker_context 
docker context create aci $docker_context
docker context use $docker_context

docker compose -f docker-compose.prod.yml up

az container show --name davidsauthtestcg8zajs7-main --resource-group $resource_group --query "ipAddress.fqdn"
