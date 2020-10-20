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
  chart_version = "0.3.0"
  environment = "production"
  extra_answers = {
    "moneytree.forceMakerOrders" = true
    "moneytree.coinbase.useSandbox" = false
    "moneytree.enableDebugLogs" = false
    "moneytree.maxOpenOrders" = 4
    "moneytree.disableFees" = true
    "moneytree.targetReturn" = 0.003
    "moneytree.reversalSpread" = 0.001
    "moneytree.cycleDelay" = "1s"

    "moneytree.coinbase.key" = local.secrets.coinbase.key
    "moneytree.coinbase.passphrase" = local.secrets.coinbase.passphrase
    "moneytree.coinbase.secret" = local.secrets.coinbase.secret

    "coinbase.websocket.orderReceivedHandlerInputBufferSize" = 16
    "coinbase.websocket.orderOpenHandlerInputBufferSize" = 16
    "coinbase.websocket.orderDoneHandlerInputBufferSize" = 16
    "coinbase.websocket.orderMatchHandlerInputBufferSize" = 16
    "coinbase.websocket.orderChangeHandlerInputBufferSize" = 16
  }
}