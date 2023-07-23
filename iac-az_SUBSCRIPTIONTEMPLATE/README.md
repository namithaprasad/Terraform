This Subscription template can be copied an entire folder, then used to manage an Azure Subscription after following these steps:

--- Prep steps for initial Subscription creation 0. Create Subscription via https://ea.azure.com
0a. Move Subscription from Asahi Tenant to Global Asahi Tenant (temporary until EA changes)
0b. In Global Asahi Tenant, grant yourself "Owner" role temporarily
0c. Rename Subscription (may not be an option for an hour or so)
0d. Move Subscription into relevant Management Group

--- Terraform and pipeline steps

1. Create SPN and Subscription Variable in iac-az_TENANT\terraform\serviceprincipals
2. Name the folder "iac-az_SUBSCRIPTION" where "SUBSCRIPTION" is the name of the Subscription, such as "Platform-Hub"
3. Replace all "EEE" references in the folder, with the Environment code - prd | pdr | dev | tst | sbx (3 char lower)
4. Replace all "XXX" references in the folder, with the Subscription code - cub | mgt | hub | idy | sap (3-9 char lower)
5. Replace all ".CC." references in the folder, with the CIDR range 3rd octet - ".16." | ".17." | ".18."
6. Replace all "VN/VN" references in the folder, with the virtual network CIDR range 4th octet and mask - "0/24" | "0/23"
   #7. Replace all "SNW/SNW" references in the folder, with the web subnet CIDR range 4th octet and mask - "0/26"
   #8. Replace all "SNA/SNA" references in the folder, with the app subnet CIDR range 4th octet and mask - "64/26"
   #9. Replace all "SND/SND" references in the folder, with the db subnet CIDR range 4th octet and mask - "128/26"
   #9a. Replace all "SNS/SNS" references in the folder, with the db subnet CIDR range 4th octet and mask - "192/28"
7. Replace all "SUBNAMESHORT" references Subscription short name without hypens like "OceaniaCubProd". This is used in pipeline yaml file for stage name which cannot have hyphens.
8. Replace all "SUBNAME" references with the Subcription Name such as "Oceania-CUB-Prod". This is used in pipelines yaml file for directory path, environment name.12. Add any additional subnet details to "workloads_env.tfvars":
   vnet1.subnets
   vnet1.subnet_names
   vnet1.route_config.route_table
9. Add "azurerm_virtual_network_peering" resource section to "iac-az-Platform-Hub\terraform\workloads\az-vnet-peering.tf". Modify \_env.tfvard with peering data.
10. Add the "Log Analytics Contributor Role" for the SPN (created in step #1) in iac-az_Platform-Management\terraform\services\az-la.tf.
11. Add the "Network Contributor" and "User Access Administrator" role for the spn-prd-iac-hub to the newly created subscription in the file iac-az_TENANT\terraform\serviceprincipals\az-role-assignments_peering.tf.
12. Verify TAG values in services_main.tf and workloads_main.tf

-- DevOps ServicePrincipal - Cross subscription permissions
1. The SPN for DevOps ( eg. spn-prd-iac-iac-sap-001 ) needs Keyvault Secrets User permission to the Platform-Management > kvprdmgtstd001 keyvault
2. It also requires "Storage Account Contributor" and "Storage Blob Data Contributor" role to the Platform-Management > stasahigmgtprd storage account.

--- Azure DevOps steps

1. Run (updated) Tenant Pipeline
2. Create Service Connection
3. Create DevOps Pipeline by importing existing YAML
4. Create Environment- use the same name as "SUBNAME" used above ( this is referred in the Azure Pipeline YAML )
5. Under the Environment > Security --> Assign Project Administrators 'Administrator' role.
6. Create an Approval for the environment. See [this](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass#approvals)
7. Run Pipeline
