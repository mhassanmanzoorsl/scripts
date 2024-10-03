# Following are different az quires and Bash scripts to check Environment Variables in Funcation App(s) in a Resource Group
 
- Query to Get a specific Env Variable from a function app in a RG

```
az functionapp config appsettings list --resource-group "RESOURCE_GROUP" --name "FUNCTION_APP" --query "[?name=='ENV_VAR_NAME'].{name:name, value:value}" --output table
```

- Query to Get all the Env Variables from a function app in a RG

```
az functionapp config appsettings list --resource-group "RESOURCE_GROUP" --name "FUNCTION_APP" --output table
```

- Query to Get a number of specific Env Variables from a function app in a RG

```
az functionapp config appsettings list --resource-group "RESOURCE_GROUP" --name "FUNCTION_APPaa" --query "[?name=='ENV_VAR_NAME_1' || name=='ENV_VAR_NAME_2' || name=='ENV_VAR_NAME_3'].{name:name, value:value}" --output table
```

- For a Specific ENV Variable in all Functaion apps in a RG

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

- For a number of Specific ENV Variables in all Functaion apps in a RG

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
- To get all environment variables for all Function Apps present in a Resource Group
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

- For a number of specfic ENV Var which is not using key vault in all Function app in a RG

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
