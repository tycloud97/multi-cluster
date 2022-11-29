module "cluster_manager" {
  source = "../modules/cluster"

  name = "cluster-manager"
}

module "ap" {
  source = "../modules/cluster"

  name = "ap"
}

module "eu" {
  source = "../modules/cluster"

  name   = "eu"
}
