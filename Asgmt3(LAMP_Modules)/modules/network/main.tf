#VPC
resource "aws_vpc" "this" {
    cidr_block              = var.vpc_cidr
    enable_dns_support      = true
    enable_dns_hostnames    = true

    tags = {
        Name = "${var.environment}-${var.project_name}-vpc"
    }
}

#Subnet
resource "aws_subnet" "this" {
    for_each = {
        for idx, subnet in var.subnets : "${subnet.purpose}-${subnet.availability_zone}" => subnet
    }

    vpc_id                  = aws_vpc.this.id
    cidr_block              = each.value.cidr_block
    availability_zone       = each.value.availability_zone
    map_public_ip_on_launch = each.value.map_public_ip_on_launch

    tags = {
        Name = "${var.environment}-${each.value.purpose}-${each.value.availability_zone}-${each.value.subnet_type}"
        Environment = var.environment
        Purpose = each.value.purpose
        Type = each.value.subnet_type
    }
}

# IGW
resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "${var.environment}-${var.project_name}-igw"
        Environment = var.environment
    }
}

#RT(public)
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.this.id
    }

    tags = {
        Name = "${var.environment}-${var.project_name}-public-rt"
        Environment = var.environment
        Type = "public"
    }
}

#RT(private)
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.this.id

    tags = {
        Name = "${var.environment}-${var.project_name}-private-rt"
        Environment = var.environment
        Type = "private"
    }
}

#RT Association
resource "aws_route_table_association" "public" {
    for_each = {
        for k, v in aws_subnet.this : k => v
        if v.tags["Type"] == "public"
    }

    subnet_id = each.value.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    for_each = {
        for k, v in aws_subnet.this : k => v
        if v.tags["Type"] == "private"
    }

    subnet_id       = each.value.id
    route_table_id  = aws_route_table.private.id
}

#SG
resource "aws_security_group" "this" {
    for_each = var.security_groups

    name = "${var.environment}-${each.value.name}"
    description = each.value.description
    vpc_id = aws_vpc.this.id

    dynamic "ingress" {
        for_each = each.value.ingress_rules
        content {
            from_port   = ingress.value.from_port
            to_port     = ingress.value.to_port
            protocol    = ingress.value.protocol
            cidr_blocks = ingress.value.cidr_blocks
        }
    }
    dynamic "egress" {
        for_each = each.value.egress_rules
        content {
            from_port   = egress.value.from_port
            to_port     = egress.value.to_port
            protocol    = egress.value.protocol
            cidr_blocks = egress.value.cidr_blocks
        }
    }

    tags = {
        Name = "${var.environment}-${each.value.name}"
        Environment = var.environment
    }
}

#Subnet Groups(RDS)
resource "aws_db_subnet_group" "this" {
    name = "${var.environment}-${var.project_name}-rds-subnet-group"
    subnet_ids = [for k, v in aws_subnet.this : v.id if v.tags["Type"] == "private" ]

    tags = {
        Name = "${var.environment}-${var.project_name}-rds-subnet-group"
        Environment = var.environment
    }
}