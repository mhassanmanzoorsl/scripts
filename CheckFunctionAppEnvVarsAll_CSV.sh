#!/bin/bash
# Replace these with your actual values
RESOURCE_GROUP="PL-DevOps-POC-RG"

# Define an array of environment variable names to check
ENV_VARS=("AzureWebJobsStorage" "AzureWebJobsDashboard" "CommonStorageConnectionString" "CosmosConnectionString")

# Output CSV file name based on the resource group
CSV_FILE="${RESOURCE_GROUP}.csv"

# Create CSV file and add the header (FunctionAppName and environment variable names)
# Use double quotes to ensure correct CSV formatting
HEADER="\"FunctionAppName\""
for VAR in "${ENV_VARS[@]}"; do
    HEADER="${HEADER},\"$VAR\""
done
echo "$HEADER" > "$CSV_FILE"

# List all function apps and check for the environment variables in each
az functionapp list --resource-group "$RESOURCE_GROUP" --query "[].name" --output tsv | while read FUNCTION_APP; do
    # Initialize a line with the Function App name
    CSV_LINE="\"$FUNCTION_APP\""
    
    # Fetch all app settings for the current function app
    APP_SETTINGS=$(az functionapp config appsettings list --resource-group "$RESOURCE_GROUP" --name "$FUNCTION_APP" --output json)

    # For each environment variable, get its value from the app settings
    for VAR in "${ENV_VARS[@]}"; do
        VALUE=$(echo "$APP_SETTINGS" | jq -r ".[] | select(.name==\"$VAR\") | .value")
        
        # If the value is empty or null, set it to 'Not Found'
        if [ -z "$VALUE" ] || [ "$VALUE" == "null" ]; then
            VALUE="Not Found"
        fi
        
        # Escape any quotes in the value for CSV compatibility and append it to the CSV line
        VALUE=$(echo "$VALUE" | sed 's/"/""/g') # Escape double quotes
        CSV_LINE="${CSV_LINE},\"$VALUE\""
    done
    
    # Append the line to the CSV file
    echo "$CSV_LINE" >> "$CSV_FILE"
    
    echo "  ====  Processed Function App: $FUNCTION_APP  ====  "
done

echo "Output saved to $CSV_FILE"
