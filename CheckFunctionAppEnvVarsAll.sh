#!/bin/bash
# Replace these with your actual values
RESOURCE_GROUP="PL-DevOps-POC-RG"

# Define an array of environment variable names to check
ENV_VARS=("AzureWebJobsStorage" "AzureWebJobsDashboard" "CommonStorageConnectionString" "CosmosConnectionString")

# List all function apps and check for the environment variables in each
az functionapp list --resource-group "$RESOURCE_GROUP" --query "[].name" --output tsv | while read FUNCTION_APP; do
    echo "  ====  Checking Function App: $FUNCTION_APP  ====  "
    
    # Fetch all app settings for the current function app and filter by the desired environment variables
    az functionapp config appsettings list \
        --resource-group "$RESOURCE_GROUP" \
        --name "$FUNCTION_APP" \
        --query "[?name=='${ENV_VARS[0]}' || name=='${ENV_VARS[1]}' || name=='${ENV_VARS[2]}' || name=='${ENV_VARS[3]}'].{name:name, value:value}" \
        --output table

    echo "  "
done
