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
  chart_version = "0.6.0"
  environment = "staging"
  extra_answers = {
    "moneytree.forceMakerOrders" = false
    "moneytree.maxOpenPairs" = 1
    "moneytree.disableFees" = false
    "moneytree.targetReturn" = 0.002
    "moneytree.service.port" = 44444
    "moneytree.service.clusterIP" = "10.128.35.200"

    "moneytree.coinbase.key" = "7f80661cd3fbaa1d52ea87d565074d4c"
    "moneytree.coinbase.passphrase" = "u0w273x7hw"
    "moneytree.coinbase.secret" = "cFqrTqWLw3nS/wTalxoLKLLGvWVD/fAMcg8T1a0YPTCbnjOyC0M9c4Mqt4THWx0vrSXa2EyfoKxy6plwC9KKIg=="
  }
}