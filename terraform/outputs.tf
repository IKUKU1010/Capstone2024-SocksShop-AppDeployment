output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}


 output "eks_managed_node_group_ami_id" = {
    value = data.aws_ami.latest-ubuntu-noble-24-04-image.id
  }