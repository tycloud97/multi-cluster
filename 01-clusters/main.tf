module "cluster_manager" {
  source = "../modules/cluster"

  name   = "cluster-manager"
}

module "ap" {
  source = "../modules/cluster"

  name   = "ap"
}

# resource "local_file" "kubeconfig_cluster_manager" {
#   filename = "../kubeconfig-cluster-manager"
#   content  = module.cluster_manager.kubeconfig
# }

# module "ap" {
#   source = "../modules/cluster"

#   name   = "ap"
#   region = "ap-south"
# }

# resource "local_file" "kubeconfig_ap" {
#   filename = "../kubeconfig-ap"
#   content  = module.ap.kubeconfig
# }

# module "us" {
#   source = "../modules/cluster"

#   name   = "us"
#   region = "us-west"
# }

# resource "local_file" "kubeconfig_us" {
#   filename = "../kubeconfig-us"
#   content  = module.us.kubeconfig
# }

# module "eu" {
#   source = "../modules/cluster"

#   name   = "eu"
#   region = "eu-west"
# }

# resource "local_file" "kubeconfig_eu" {
#   filename = "../kubeconfig-eu"
#   content  = module.eu.kubeconfig
# }
# output "cluster_certificate_authority_data" {
#   description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
#   value       = module.cluster_manager.cluster_ca_certificate
# }

# output "cluster_endpoint" {
#   description = "The endpoint for your EKS Kubernetes API."
#   value       = module.cluster_manager.cluster_endpoint
# }

# output "cluster_id" {
#   description = "The name/id of the EKS cluster."
#   value       = module.cluster_manager.cluster_id
# }

# output "ap_cluster_certificate_authority_data" {
#   description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
#   value       = module.ap.cluster_ca_certificate
# }

# output "ap_cluster_endpoint" {
#   description = "The endpoint for your EKS Kubernetes API."
#   value       = module.ap.cluster_endpoint
# }

# output "ap_cluster_id" {
#   description = "The name/id of the EKS cluster."
#   value       = module.ap.cluster_id
# }