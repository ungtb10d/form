locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  env         = local.environment_vars.locals.environment
  project     = local.environment_vars.locals.project
  subenv      = local.environment_vars.locals.subenv
  product     = local.environment_vars.locals.product
  name_prefix = "${local.project}-${local.env}-${local.subenv}-${local.product}"
  region  = local.region_vars.locals.aws_region
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "git::https://github.com/18F/formservice-iac-modules.git//elastic-beanstalk-app"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# dependencies
dependencies {
  paths = ["../../vpc", "../s3", "../documentdb", "../../../mgmt/security", "../../../mgmt/formio-code-bucket"]
}
dependency "vpc" { config_path = "../../vpc" }
dependency "s3" { config_path = "../s3" }
dependency "acct-security" { config_path = "../../../mgmt/security"}
dependency "code-bucket" { config_path = "../../../mgmt/formio-code-bucket"}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  name_prefix = "${local.name_prefix}"

  code_bucket      = dependency.code-bucket.outputs.s3_bucket_name
  code_version     = "formio-hub/multicontainer-gov-7-1-6.zip"
  code_version_id  = "v1"


}
