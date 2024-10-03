# Following are various Azure CLI queries and Bash scripts for checking environment variables in Function App(s) within a resource group.
 
- This command retrieves and displays the value of a specific environment variable from a Function App within an Azure resource group in a table format.

```
az functionapp config appsettings list --resource-group "RESOURCE_GROUP" --name "FUNCTION_APP" --query "[?name=='ENV_VAR_NAME'].{name:name, value:value}" --output table
```

- This command retrieves and displays all environment variables (app settings) for a specified Function App within an Azure resource group in a table format.

```
az functionapp config appsettings list --resource-group "RESOURCE_GROUP" --name "FUNCTION_APP" --output table
```

- This command retrieves the values of specific environment variables from a Function App in Azure, filtering for three specified variable names and displaying the results in a table format.

```
az functionapp config appsettings list --resource-group "RESOURCE_GROUP" --name "FUNCTION_APPaa" --query "[?name=='ENV_VAR_NAME_1' || name=='ENV_VAR_NAME_2' || name=='ENV_VAR_NAME_3'].{name:name, value:value}" --output table
```

- This script checks for a single specific environment variable in all Function Apps within a specified resource group and displays its value if present.

```
#!/bin/bash

# Variables
RESOURCE_GROUP="your-resource-group-name"  # Replace with your resource group name
ENV_VAR_NAME="your-environment-variable"   # Replace with the environment variable name you're checking

# Get all Function Apps in the resource group
FUNCTION_APPS=$(az functionapp list --resource-group "$RESOURCE_GROUP" --query "[].name" --output tsv)

# Iterate over each Function App and get the environment variable value
for FUNCTION_APP in $FUNCTION_APPS
do
    echo "Checking Function App: $FUNCTION_APP"
    
    # Get the Function App settings and filter for the specified environment variable
    az functionapp config appsettings list \
        --resource-group "$RESOURCE_GROUP" \
        --name "$FUNCTION_APP" \
        --query "[?name=='$ENV_VAR_NAME'].{name:name, value:value}" \
        --output table
    echo "  "
done
```

- This script checks for specific environment variables across all Function Apps within a resource group and displays their values in a table format.

```
#!/bin/bash

# Replace these with your actual values
RESOURCE_GROUP="your-resource-group-name"

# Define an array of environment variable names to check
ENV_VARS=("ENV_VAR_NAME_1" "ENV_VAR_NAME_2" "ENV_VAR_NAME_3")

# List all function apps and check for the environment variables in each
az functionapp list --resource-group "$RESOURCE_GROUP" --query "[].name" --output tsv | while read FUNCTION_APP; do
    echo "Checking Function App: $FUNCTION_APP"
    
    # Fetch all app settings for the current function app and filter by the desired environment variables
    az functionapp config appsettings list \
        --resource-group "$RESOURCE_GROUP" \
        --name "$FUNCTION_APP" \
        --query "[?name=='${ENV_VARS[0]}' || name=='${ENV_VARS[1]}' || name=='${ENV_VARS[2]}'].{name:name, value:value}" \
        --output table

    echo "  "
done
```
- This script retrieves and displays all environment variables for each Function App in a specified Azure resource group.
```
#!/bin/bash

# Replace with your actual resource group name
RESOURCE_GROUP="your-resource-group-name"

# List all function apps and get all environment variables for each
az functionapp list --resource-group "$RESOURCE_GROUP" --query "[].name" --output tsv | while read FUNCTION_APP; do
    echo "Checking Function App: $FUNCTION_APP"
    # Get all app settings (environment variables) for the Function App
    az functionapp config appsettings list \
        --resource-group "$RESOURCE_GROUP" \
        --name "$FUNCTION_APP" \
        --output table
    echo "   "
done
```

- This script checks specific environment variables in all Function Apps within a resource group and identifies whether they are not using Azure Key Vault references.

```
#!/bin/bash

# Replace these with your actual values
RESOURCE_GROUP="your-resource-group-name"

# Define an array of environment variable names to check
ENV_VARS=("ENV_VAR_NAME_1" "ENV_VAR_NAME_2" "ENV_VAR_NAME_3")

# List all function apps and check for the environment variables in each
az functionapp list --resource-group "$RESOURCE_GROUP" --query "[].name" --output tsv | while read FUNCTION_APP; do
    echo "Checking Function App: $FUNCTION_APP"
    # Fetch all app settings for the current function app and filter by the desired environment variables
    az functionapp config appsettings list \
        --resource-group "$RESOURCE_GROUP" \
        --name "$FUNCTION_APP" \
        --query "[?name=='${ENV_VARS[0]}' || name=='${ENV_VARS[1]}' || name=='${ENV_VARS[2]}'].{name:name, value:value}" \
        --output tsv | while read NAME VALUE; do
            # Check if the value contains a Key Vault reference, skip if it does
            if [[ $VALUE != *@Microsoft.KeyVault* ]]; then
                echo "Variable: $NAME, Value: $VALUE (not using Key Vault)"
            fi
        done
    echo "   "
done
```
