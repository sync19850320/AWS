#リージョン
provider "aws" {
    region = var.region
}

#network
module "network" {
    source = "./modules/network"

    environment     = var.environment
    project_name    = var.project_name
    vpc_cidr        = var.vpc_cidr
    subnets         = var.subnets
    security_groups = var.security_groups
}

#IAM
module "iam" {
    source = "./modules/iam"

    environment = var.environment
    project_name = var.project_name
}

#EC2
module "ec2" {
    source = "./modules/ec2"

    environment = var.environment
    project_name = var.project_name
    bastion = var.bastion

    public_subnet_id = module.network.public_subnet_ids["bastion-ap-northeast-1a"]
    bastion_sg_id = module.network.security_group_ids["bastion"]

    iam_instance_profile = module.iam.ec2_instance_profile_name

    db_endpoint = module.rds.endpoint
    db_user = var.rds_config.username
    db_pass = var.rds_config.password
    db_name = var.rds_config.db_name
}

#RDS
module "rds" {
    source = "./modules/rds"

    environment = var.environment
    project_name = var.project_name
    db_subnet_group_name = module.network.db_subnet_group_name
    rds_sg_id = module.network.security_group_ids["rds"]
    rds_config = var.rds_config
}

