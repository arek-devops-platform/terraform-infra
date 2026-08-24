# Remote state backend - intentionally left as a partial configuration.
#
# No storage account name, container name, or keys are hardcoded here, and
# no secret ever needs to live in this file or in version control:
# `use_azuread_auth = true` tells Terraform to authenticate to the storage
# account with your own Azure AD identity (your `az login` session locally,
# or a federated/OIDC identity in CI) instead of a storage account access key.
#
# The actual storage account must already exist (created once, out-of-band,
# before this backend can be used) and its details are supplied at
# `terraform init` time, e.g.:
#
#   terraform init \
#     -backend-config="resource_group_name=<state-resource-group>" \
#     -backend-config="storage_account_name=<state-storage-account>" \
#     -backend-config="container_name=tfstate" \
#     -backend-config="key=terraform-infra.tfstate"
#
# IMPORTANT: once a non-default `backend "azurerm" {}` block like this one is
# declared, Terraform does NOT fall back to local state if the parameters
# above are missing. It commits to the azurerm backend: `terraform init`
# either prompts interactively for each missing value (and errors if none is
# given), or - in any non-interactive run such as CI (`-input=false`) - fails
# immediately with an error like "storage_account_name is required". There is
# no silent fallback. The storage account must be bootstrapped and the
# `-backend-config` values supplied before `init` will succeed at all.

terraform {
  backend "azurerm" {
    use_azuread_auth = true
  }
}
