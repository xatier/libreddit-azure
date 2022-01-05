# libreddit (Private front-end for Reddit) on Azure Cloud

Repo to quickly host [libreddit](https://github.com/spikecodes/libreddit)
on [Azure Container Instances](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview) with
[Azure Storage Files](https://docs.microsoft.com/en-us/azure/storage/files/storage-files-introduction)

## Azure Container Instances setup

- update `<dnsNameLabel>.<azure region>` in `Caddyfile`.
- run `certs.sh` to generate client side certificate.
- update `AZURE_GROUP_NAME` in `run.sh` and `azure-storage-create.sh`.
- update `LOCATION` in `azure-storage-create.sh`.
- update `<azure region>` in `setup.yaml`.
- apply other desired settings in `setup.yaml`

```bash
az login --use-device-code --tenant <yourdiretory.onmicrosoft.com>

# upload Caddyfile to Azure Storage Files
# this script will print `storageAccountName` and `storageAccountKey`
./azure-storage-create.sh

# update `storageAccountName` and `storageAccountKey` in `setup.yaml`

# deploy container instance
./run.sh
```

### Use base64-encoded secrets for Caddyfile and ca.certs

We can also use [base64-encode configuration files](https://docs.microsoft.com/en-us/azure/container-instances/container-instances-container-group-ssl#base64-encode-secrets-and-configuration-file) in the mounted volumes. Simply
Remove the comments in `setup.yaml` and replace with the base64 strings.
