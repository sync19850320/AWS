resource "aws_db_parameter_group" "this" {
    family = "mysql8.0"
    name   = "${var.environment}-${var.project_name}-mysql8-params"

    parameter {
        name  = "character_set_server"
        value = "utf8mb4"
    }

    parameter {
        name  = "character_set_client"
        value = "utf8mb4"
    }

    parameter {
        name  = "character_set_connection"
        value = "utf8mb4"
    }

    parameter {
        name  = "character_set_database"
        value = "utf8mb4"
    }

    parameter {
        name  = "character_set_results"
        value = "utf8mb4"
    }

    tags = {
        Name = "${var.environment}-${var.project_name}-mysql8-params"
        Environment = var.environment
    }
}

resource "aws_db_instance" "this" {
    db_name                 = var.rds_config.db_name
    identifier              = "${var.environment}-${var.project_name}-${var.rds_config.identifier}"
    instance_class          = var.rds_config.instance_class
    allocated_storage       = var.rds_config.allocated_storage
    engine                  = var.rds_config.engine
    engine_version          = var.rds_config.engine_version
    username                = var.rds_config.username
    password                = var.rds_config.password
    db_subnet_group_name    = var.db_subnet_group_name
    vpc_security_group_ids  = [var.rds_sg_id]
    skip_final_snapshot     = var.rds_config.skip_final_snapshot
    publicly_accessible     = var.rds_config.publicly_accessible
    multi_az                = var.rds_config.multi_az
    availability_zone       = var.rds_config.availability_zone
    parameter_group_name    = aws_db_parameter_group.this.name

    tags = {
        Name = "${var.environment}-${var.project_name}-rds"
        Environment = var.environment
    }
}