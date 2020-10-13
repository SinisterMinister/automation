terraform {
  backend "s3" {}
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
  source_file = var.sops_file_path
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
    name = "moneytree"
}

resource rancher2_namespace moneytree {
    project_id = rancher2_project.moneytree.id
    name = "moneytree"
}

resource rancher2_app moneytree {
    catalog_name = "hub"
    name = "moneytree"
    project_id = rancher2_project.moneytree.id
    target_namespace = rancher2_namespace.moneytree.name
    template_name = "moneytree"
    template_version = var.chart_version
    answers = {
        "moneytree.image.digest" = data.docker_registry_image.moneytree.sha256_digest
    }
}