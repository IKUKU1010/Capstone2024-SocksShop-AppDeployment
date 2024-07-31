# deploy the k8s cluster via terraform

provider "aws" {
  region = "us-east-2" 
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name = "socks-shop-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}


enable_nat_gateway = true

single_nat_gateway = true
enable_dns_hostnames = true


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "socks-shop-cluster"
  cluster_version = "1.30"

  cluster_endpoint_public_access = true


  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    # Use Ubuntu AMI
    ami_type = "CUSTOM"
  }

  eks_managed_node_group = {
    work-node1 = {
      name    = "sockapp-node1"
      ami = data.aws_ami.latest-ubuntu-noble-24-04-image.id
      instance_types = ["t2.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 2
    }



    work-node2 = {
         
      name    = "sockapp-node2"
      ami = data.aws_ami.latest-ubuntu-noble-24-04-image.id
      instance_types = ["t2.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 2
    }


  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true