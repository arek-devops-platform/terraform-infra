# Remote state backend - the SAME Azure Storage Account as the other
# Terraform stages in this repository (root and kubernetes/), but its own
# blob key so this stage's state never collides with either of theirs.
# Neither the root nor kubernetes/ stage's backend key is changed by this
# file.
#
# No storage account name, container name, or keys are hardcoded here, and
# no secret ever needs to live in this file or in version control:
# `use_azuread_auth = true` authenticates to the storage account with your
# own Azure AD identity, not a storage account access key.
#
#   terraform init \
#     -backend-config="resource_group_name=<state-resource-group>" \
#     -backend-config="storage_account_name=<state-storage-account>" \
#     -backend-config="container_name=tfstate" \
#     -backend-config="key=github.tfstate"
#
# This stage manages GitHub resources, not Azure ones - it does not need the
# ARM_* / azurerm provider credentials the other two stages use. It still
# needs Azure AD auth to reach the state storage account itself (the same
# identity used for `az login` locally, or a CI identity later), plus its
# own GITHUB_TOKEN for the github provider (see providers.tf).
#
# IMPORTANT: once a non-default `backend "azurerm" {}` block like this one is
# declared, Terraform does NOT fall back to local state if the parameters
# above are missing - `init` fails loudly instead. See the root stage's
# backend.tf for the full explanation of this behavior.

terraform {
  backend "azurerm" {
    use_azuread_auth = true
  }
}
