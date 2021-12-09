#!/usr/bin/env bash

set -x

AZURE_GROUP_NAME=""
AZURE_CONTAINER_NAME="libreddit"
AZURE_STORAGE_ACCOUNT_NAME="$AZURE_CONTAINER_NAME$((1 + RANDOM % 1000))"
LOCATION=""

# create the storage account
az storage account create \
    --resource-group "$AZURE_GROUP_NAME" \
    --name "$AZURE_STORAGE_ACCOUNT_NAME" \
    --location "$LOCATION" \
    --sku Standard_LRS

# create the file share
az storage share create \
    --name "$AZURE_CONTAINER_NAME" \
    --account-name "$AZURE_STORAGE_ACCOUNT_NAME"

STORAGE_KEY=$(
    az storage account keys list \
        --resource-group "$AZURE_GROUP_NAME" \
        --account-name "$AZURE_STORAGE_ACCOUNT_NAME" \
        --query "[0].value" --output tsv
)

# upload Caddyfile
az storage file upload \
    --account-key "$STORAGE_KEY" \
    --account-name "$AZURE_STORAGE_ACCOUNT_NAME" \
    --share-name "$AZURE_CONTAINER_NAME" \
    --source Caddyfile

echo "$AZURE_STORAGE_ACCOUNT_NAME"
echo "$STORAGE_KEY"
