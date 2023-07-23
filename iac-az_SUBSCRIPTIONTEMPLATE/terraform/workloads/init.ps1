
terraform init -backend-config=key="EEE-workloads.tfstate" `
    -backend-config=access_key="$env:MYVAR_AHH_BACKEND_CONFIG_KEY"  `
    -backend-config=storage_account_name="$env:MYVAR_AHH_TF_STORAGE_ACCOUNT" `
    -backend-config=container_name="$env:MYVAR_AHH_TF_CONTAINER" `
    -backend-config=resource_group_name="$env:MYVAR_AHH_TF_RESOURCE_GROUP" `
    -backend-config=subscription_id="$env:MYVAR_AHHY_TF_SUBSCRIPTION_ID" `
    -backend-config=tenant_id="$env:MYVAR_AHH_TENANT_ID"  `
    -backend-config=client_id="$env:MYVAR_AHH_CLIENT_ID" `
    -backend-config=client_secret="$env:MYVAR_AHH_CLIENT_SECRET"