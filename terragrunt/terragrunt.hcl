remote_state {
  backend = "s3"
  
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

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