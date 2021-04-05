locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  env         = local.environment_vars.locals.environment
  project     = local.environment_vars.locals.project
  name_prefix = "${local.project}-${local.env}-tf"
  region  = local.region_vars.locals.aws_region
}

# MODULE
terraform {
  source = "git@github.com:18F/formservice-iac-modules.git//elastic-beanstalk"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# DEPENDENCIES
dependencies {
  paths = ["../vpc", "../formio-s3", "../formio-docdb"]
}
dependency "vpc" { config_path = "../vpc" }
dependency "formio-s3" { config_path = "../formio-s3" }
dependency "formio-docdb" { config_path = "../formio-docdb" }


# MAIN
inputs = {
  name_prefix = "${local.name_prefix}-hub"

  vpc_id  = dependency.vpc.outputs.vpc_id
  loadbalancer_subnets = dependency.vpc.outputs.public_subnet_ids
  application_subnets = dependency.vpc.outputs.private_subnet_ids
  allowed_security_groups = dependency.vpc.outputs.default_security_group_id
  app_version_bucket      = "faas-test-hub-formio-bucket"
  app_version_source      = "2021092J8k-multicontainer-gov.zip"

  instance_type = "t3.medium"
  autoscale_min = 3
  autoscale_max = 5
  key_name = "faas-test-bastion"
  #ssl_cert = "arn:aws-us-gov:acm:us-gov-west-1:306851503416:certificate/9550f720-8547-45c2-a771-3aff81bf45c9" # *.appsquared.io

  ADMIN_EMAIL = get_env("FORMIO_ADMIN_EMAIL")
  ADMIN_PASS  = get_env("FORMIO_ADMIN_PASS")
  DB_SECRET   = get_env("FORMIO_DB_SECRET")
  JWT_SECRET  = get_env("FORMIO_JWT_SECRET")

  LICENSE_KEY    = get_env("FORMIO_LICENSE_KEY")
  MONGO          = "mongodb://${dependency.formio-docdb.outputs.master_username}:${get_env("TF_VAR_master_password")}@${dependency.formio-docdb.outputs.endpoint}:27017/formio?ssl=true"
  PORTAL_ENABLED = "true"
  VPAT           = "true"

  FORMIO_S3_BUCKET = dependency.formio-s3.outputs.s3_bucket_name  # s3 bucket name
  FORMIO_S3_REGION = local.region
  FORMIO_S3_KEY    = dependency.formio-s3.outputs.s3_user_key     # pdf user access key
  FORMIO_S3_SECRET = dependency.formio-s3.outputs.s3_user_secret  # pdf user secret key  

  # PROXY           = "true"
  # DEFAULT_DATABASE  = "formiosubsvr"
  # PER_PROJECT_DBS = "true"
  # PORT            = "3000"

}