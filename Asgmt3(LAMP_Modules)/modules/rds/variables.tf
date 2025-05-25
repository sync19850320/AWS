variable "environment" {
    description = "Environment(dev/staging/prod)"
    type = string
}

variable "project_name" {
    description = "Name tag to apply to resources"
    type = string
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