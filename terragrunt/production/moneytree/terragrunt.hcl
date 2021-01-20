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
  chart_version = "0.4.3"
  environment = "production"
  extra_answers = {
    "moneytree.forceMakerOrders" = true
    "moneytree.coinbase.useSandbox" = false
    "moneytree.enableDebugLogs" = false
    "moneytree.maxOpenPairs" = 4
    "moneytree.disableFees" = false
    "moneytree.targetReturn" = 0.001
    "moneytree.service.port" = 43210
    "moneytree.service.clusterIP" = "10.128.35.100"

    "moneytree.coinbase.key" = local.secrets.coinbase.key
    "moneytree.coinbase.passphrase" = local.secrets.coinbase.passphrase
    "moneytree.coinbase.secret" = local.secrets.coinbase.secret
  }
}