terraform {
  # Deploy version v0.0.1 in prod
  source = "${get_parent_terragrunt_dir()}/../terraform//${path_relative_to_include()}"
}

remote_state {
  backend = "s3"
  config = {
    bucket = "sinimini"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "lock-table"
  }
}

inputs = {
    sops_file_path = "${get_parent_terragrunt_dir()}/secrets.sops.yaml"
}