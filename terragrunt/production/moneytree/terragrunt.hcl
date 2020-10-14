locals {
  secrets = yamldecode(sops_decrypt_file(find_in_parent_folders("secrets.sops.yaml")))
}

terraform {
  # Deploy version v0.0.1 in prod
  source = "${get_parent_terragrunt_dir()}/../terraform//moneytree?ref=origin/master"
}

# stage/mysql/terragrunt.hcl
include {
  path = find_in_parent_folders()
}

inputs = {
  chart_version = "0.2.4"
  environment = "production"
  extra_answers = {
    "moneytree.forceMakerOrders" = false
    "moneytree.coinbase.useSandbox" = false
    "moneytree.enableDebugLogs" = false
    "moneytree.maxOpenOrders" = 4

    "moneytree.coinbase.key" = local.secrets.coinbase.key
    "moneytree.coinbase.passphrase" = local.secrets.coinbase.passphrase
    "moneytree.coinbase.secret" = local.secrets.coinbase.secret
  }
}