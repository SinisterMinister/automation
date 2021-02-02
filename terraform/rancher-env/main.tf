provider "sops" {}

# provider "docker" {
#   registry_auth {
#     address = "hub.sinimini.com"
#     username = data.sops_file.secrets.data["jcr.user"]
#     password = data.sops_file.secrets.data["jcr.password"]
#   }
# }

provider rancher2 {
    api_url = "https://rancher.sinimini.com"
    access_key = data.sops_file.secrets.data["rancher.accessKey"]
    secret_key = data.sops_file.secrets.data["rancher.secretKey"]
}

locals {
  sops_file_path = var.sops_file_path
  name = var.environment
  working_directory = var.working_directory
  manifest = yamldecode(templatefile("${local.working_directory}/manifest.yaml"),{
    "environment" = local.name
  })
  
  raw_catalogs = yamlencode({for catalog in local.manifest.catalogs : catalog.name => catalog})
  raw_apps = yamlencode({for app in local.manifest.charts : app.name => app})

  catalogs = yamldecode(local.manifest.live ? local.raw_catalogs : "{}")
  apps = yamldecode(local.manifest.live ? local.raw_apps : "{}")
}

data sops_file secrets {
  source_file = local.sops_file_path
}

# data docker_registry_image moneytree {
#     name = "hub.sinimini.com/docker/moneytree:latest"
# }


resource rancher2_project project {
  cluster_id = "local"
  name = local.name
}

resource rancher2_catalog catalogs {
  for_each = local.catalogs
  name = "${each.value.name}-${local.name}"
  url = each.value.url
  version = "helm_v3"
}

resource rancher2_namespace namespace {
    project_id = rancher2_project.project.id
    name = local.name
}

resource rancher2_app moneytree {
  for_each = local.apps
  catalog_name = "${each.value.catalog}-${local.name}"
  name = each.value.displayName
  project_id = rancher2_project.project.id
  target_namespace = rancher2_namespace.namespace.name
  template_name = each.value.name
  template_version = each.value.version
  values_yaml = base64encode(yamlencode(each.value.answers))
  depends_on = [ rancher2_catalog.catalogs ]
}