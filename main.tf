terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "s3" {
  source = "./modules/aws/s3"
  bucket_name = var.bucket_name
  project_name = var.project_name
  management_name = var.management_name
}

module "vpc" {
   source = "./modules/aws/vpc"
   management_name = var.management_name
   vpc_cidr_block = var.vpc_cidr_block
   jenkins_subnet_cidr_block = var.jenkins_subnet_cidr_block
   project_name = var.project_name
}

module "security_group" {
   source = "./modules/aws/security_group"
   management_name = var.management_name
   vpc_id = module.vpc.vpc_id
   project_name = var.project_name
   my_ip = var.my_ip
}

module "ec2_instance" {
   source = "./modules/aws/compute"
   management_name = var.management_name
   key_name = var.key_name
   jenkins_ami_id = var.jenkins_ami_id
   jenkins_size = var.jenkins_size
   vpc_id = module.vpc.vpc_id
   my_ip = var.my_ip   
   security_group = module.security_group.sg_id
   public_subnet = module.vpc.public_subnet_id
   project_name = var.project_name
   # role_name = var.role_name
}

# module "iam" {
#    source = "./modules/aws/iam"
#    role_name = var.role_name
# }