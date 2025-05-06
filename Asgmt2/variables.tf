#---------------------------------------------
# 変数定義
#---------------------------------------------

#リージョン
variable "aws_region" {
    description = "AWS region"
    type = string
}

#VPC CIDR
variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type = string
}

#Public Subnet CIDR
variable "public_subnet_cidr" {
    description = "CIDR block for the public subnet"
    type = string
}

#Private Subnet-a CIDR
variable "private_subnet_cidr_a" {
    description = "CIDR block for the private subnet a"
    type = string
}

#Private Subnet-c CIDR
variable "private_subnet_cidr_c" {
    description = "CIDR block for the private subnet c"
    type = string
}

#Public Subnet AZ
variable "public_subnet_az" {
    description = "AZ for the public subnet"
    type = string
}

#Public Subnet-a AZ
variable "private_subnet_az_a" {
    description = "AZ for the private subnet a"
    type = string
}

#Public Subnet-c AZ
variable "private_subnet_az_c" {
    description = "AZ for the private subnet c"
    type = string
}

#RDS
variable "rds_config" {
    description = "RDS instance configuration"
    type = object({
        db_name                  = string
        identifier               = string
        instance_class           = string
        allocated_storage        = number
        engine                   = string
        engine_version           = string
        username                 = string
        password                 = string
        availability_zone        = string
    })
}

#EC2
variable "ec2_config" {
    type = object({
        ami                     = string
        instance_type           = string
        key_name                = string
    })
}