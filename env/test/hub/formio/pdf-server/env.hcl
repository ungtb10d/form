# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment    = "test"
  project        = "faas"
  subenv         = "hub"
  product        = "formio"
  formio-project = "pdf"
}
