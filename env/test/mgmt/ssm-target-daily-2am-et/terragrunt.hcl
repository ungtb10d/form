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
  source = "git::https://github.com/18F/formservice-iac-modules.git//ssm-target"
}

// include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

// depends on maintenance window
dependency "ssm-window-daily-2am-et" {
  config_path = "../ssm-window-daily-2am-et"
}

// pass variables into module
inputs = {
  account_num                 = "${local.account_num}"
  env                         = "${local.env}"
  // maintenance window target for hub-formio and runtime-submission ecs instances
  window_id     = dependency.ssm-window-daily-2am-et.outputs.id
  name          = "ecs-daily-2am-et"
  resource_type = "INSTANCE"
  key           = "tag:Name"
  values        = ["faas-${local.env}-runtime-submission-env"]
}
