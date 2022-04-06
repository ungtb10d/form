locals {
  # Automatically load environment-level variables
  account_vars      = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  environment_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  account_num       = local.account_vars.locals.aws_account_id
  env               = local.environment_vars.locals.environment
}

// specifiy module source
terraform {
  source = "git@github.com-gsa:18F/formservice-iac-modules.git//maintenance-window"
}

// include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

// pass variables into module
inputs = {
  account_num                 = "${local.account_num}"
  env                         = "${local.env}"
  // maintenance window to run daily at 2am ET
  name     = "daily-2am-et"
  schedule = "cron(0 0 2 ? * * *)"
  duration = 2
  cutoff   = 1
}