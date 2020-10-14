terraform {
  # Deploy version v0.0.1 in prod
  source = "${get_parent_terragrunt_dir()}/../terraform//moneytree?ref=origin/master"
}

# stage/mysql/terragrunt.hcl
include {
  path = find_in_parent_folders()
}

inputs = {
  chart_version = "0.2.1"
  environment = "staging"
  extra_answers = {
    "moneytree.forceMakerOrders" = false

    "moneytree.coinbase.key" = "7f80661cd3fbaa1d52ea87d565074d4c"
    "moneytree.coinbase.passphrase" = "u0w273x7hw"
    "moneytree.coinbase.secret" = "cFqrTqWLw3nS/wTalxoLKLLGvWVD/fAMcg8T1a0YPTCbnjOyC0M9c4Mqt4THWx0vrSXa2EyfoKxy6plwC9KKIg=="
  }
}