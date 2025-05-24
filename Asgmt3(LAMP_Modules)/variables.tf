variable "project_name" {
    description = "Name tag to apply to resources"
    type        = string
}

variable "environment" {
    description = "Environment (dev/staging/prod)"
    type        = string
    default     = "dev"
}

variable "region" {
    description = "The Region for project"
    type        = string
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type        = string
}

variable "vpc_id" {
    description = "VPC ID"
    type        = string
}

variable "subnets" {
    description = "Subnets"
    type        = list(object({
        purpose                 = string 
        cidr_block              = string
        availability_zone       = string
        map_public_ip_on_launch = bool
        subnet_type             = string
    }))
}

variable "security_groups" {
    description = "Security groups"
    type        = map(object({
        name            = string
        description     = string
        ingress_rules   = list(object({
            from_port       = number
            to_port         = number
            protocol        = string
            cidr_blocks     = list(string)
        }))
        egress_rules    = list(object({
            from_port       = number
            to_port         = number
            protocol        = string
            cidr_blocks     = list(string)
        }))
    }))
}

variable "bastion" {
    description = "Bastion host configuration"
    type = object({
        instance_type = string
        key_name      = string
        ami           = string
    })
}

variable "db_subnet_group_name" {
    description = "Name of the DB subnet group"
    type = string
}

variable "rds_sg_id" {
    description = "Security group ID for RDS"
    type = string
}

variable "rds_config" {
    description = "RDS configuration"
    type = object({
        db_name             = string
        identifier          = string
        instance_class      = string
        allocated_storage   = string
        engine              = string
        engine_version      = string
        username            = string
        password            = string
        availability_zone   = string
        skip_final_snapshot = bool
        publicly_accessible = bool
        multi_az            = bool 
    })
}

variable "iam_instance_profile" {
    description = "IAM instance profile name for EC2 instance"
    type = string
}