variable "environment" {
    description = "Environment(dev/staging/prod)"
    type        = string
}

variable "project_name" {
    description = "Name tag to apply to resources"
    type        = string
}

variable "vpc_cidr" {
    description = "CIDR block fo the VPC"
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