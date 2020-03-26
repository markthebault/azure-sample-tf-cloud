# Example usage with terraform cloud

This repo just create :
- A Vnet
- 2 subnets, one private, one public
- kubernetes cluster in azure in a private subnet.
- RBAC enabled and AAD integration

## Running
**Create Azure service principal:**
- one for aks
- One for the Server AAD integration with kubernetes
- One for the Client AAD integration

**Update terraform configuration:**
You need to configure `terraform.tfvars` as follows:
```shell
cat >terraform.tfvars<<EOF
## AKS SP
client_id     = "YOUR_AKS_CLIENT_ID"
client_secret = "YOUR_AKS_CLIENT_SECRET"

#AKS AAD integration
k8s_aad_server_app_id     = "YOUR_AAD_SERVER_CLIENT_ID"
k8s_aad_server_app_secret = "YOUR_AAD_SERVER_CLIENT_SECRET"
k8s_aad_client_app_id     = "YOUR_AAD_CLIENT_CLIENT_ID"

# SSH pub key
ssh_public_key = "ssh-rsa AAAAB3NzaC1..........." #your ssh public key here
EOF
```