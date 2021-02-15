locals {
  root_deployments_dir       = get_parent_terragrunt_dir()
  relative_deployment_path   = path_relative_to_include()
  deployment_path_components = compact(split("/", local.relative_deployment_path))

  tier  = local.deployment_path_components[0]
  stack = reverse(local.deployment_path_components)[0]
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket  = "bti360-terraform-state"
    region  = "us-east-1"
    encrypt = true

    key = "${dirname(local.relative_deployment_path)}/${local.stack}.tfstate"

    dynamodb_table            = "bti360-terraform-state-locks"
    accesslogging_bucket_name = "bti360-terraform-state-logs"
  }
}

# Default the stack each deployment deploys based on its directory structure
# Can be overridden by redefining this block in a child terragrunt.hcl
terraform {
  source = "${local.root_deployments_dir}/../modules/stacks/${local.tier}/${local.stack}"
}
