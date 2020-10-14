locals {
  chart_version = var.chart_version
  sops_file_path = var.sops_file_path
  environment = var.environment
  name = "moneytree-${local.environment}"
  extra_answers = var.extra_answers

  answers = merge({
    "moneytree.image.digest" = data.docker_registry_image.moneytree.sha256_digest
    "moneytree.forceMakerOrders" = false
  }, local.extra_answers)
}

provider "sops" {}

provider "docker" {
  registry_auth {
    address = "hub.sinimini.com"
    username = data.sops_file.secrets.data["jcr.user"]
    password = data.sops_file.secrets.data["jcr.password"]
  }
}

data sops_file secrets {
  source_file = local.sops_file_path
}

data docker_registry_image moneytree {
    name = "hub.sinimini.com/docker/moneytree:latest"
}

provider rancher2 {
    api_url = "https://rancher.sinimini.com"
    access_key = data.sops_file.secrets.data["rancher.accessKey"]
    secret_key = data.sops_file.secrets.data["rancher.secretKey"]
}

resource rancher2_project moneytree {
    cluster_id = "local"
    name = local.name
}

resource rancher2_namespace moneytree {
    project_id = rancher2_project.moneytree.id
    name = local.name
}

resource rancher2_app moneytree {
    catalog_name = "hub"
    name = local.name
    project_id = rancher2_project.moneytree.id
    target_namespace = rancher2_namespace.moneytree.name
    template_name = "moneytree"
    template_version = local.chart_version
    answers = local.answers
}