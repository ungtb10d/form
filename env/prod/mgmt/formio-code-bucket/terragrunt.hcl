locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  env         = local.environment_vars.locals.environment
  project     = local.environment_vars.locals.project
  subenv      = local.environment_vars.locals.subenv
  # product     = local.environment_vars.locals.product
  name_prefix = "${local.project}-${local.env}-${local.subenv}"
  aws_account_id = local.account_vars.locals.aws_account_id
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git@github.com:18F/formservice-iac-modules.git//s3-user"
}

# dependencies
dependencies      { paths = ["../vpc", "../security"] }
dependency "vpc"  { config_path = "../vpc" }
dependency "security" { config_path = "../security" }

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name_prefix = "${local.name_prefix}"
  kms_key_arn = dependency.security.outputs.code_s3_bucket_key_arn
  aws_account_id = local.aws_account_id
}
