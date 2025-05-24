variable "environment" {
    description = "Environment(dev/staging/prod)"
    type        = string
}

variable "project_name" {
    description = "Name tag to apply to resources"
    type        = string
}

variable "bastion" {
    description = "Bastion host configuration"
    type = object({
        instance_type = string
        key_name      = string
        ami           = string
    })
}

variable "public_subnet_id" {
    description = "ID of the public subnet for bastion host"
    type        = string
}

variable "bastion_sg_id" {
    description = "ID of the security group for bastion host"
    type        = string
}

variable "db_endpoint" {
    description = "RDS endpoint"
    type = string
}

variable "db_user" {
    description = "RDS username"
    type = string
}

variable "db_pass" {
    description = "RDS password"
    type = string
}

variable "db_name" {
    description = "RDS database name"
    type = string
}

variable "iam_instance_profile" {
    description = "IAM instance profile name for EC2 instance"
    type = string
}