#プロバイダー設定
provider "aws" {
    region = var.aws_region
}

#VPC
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "main_vpc"
    }
}

#パブリックサブネット(踏み台EC2)
resource "aws_subnet" "public_a" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.public_subnet_cidr
    availability_zone       = var.public_subnet_az
    map_public_ip_on_launch = true

    tags = {
        Name = "public_subnet-a"
    }
}

#プライベートサブネット(RDS_プライマリ)
resource "aws_subnet" "private_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr_a
    availability_zone = var.private_subnet_az_a
    map_public_ip_on_launch = false

    tags = {
        Name = "private_subnet-a"
    }
}

#プライベートサブネット(RDS_セカンダリ)
resource "aws_subnet" "private_c" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr_c
    availability_zone = var.private_subnet_az_c
    map_public_ip_on_launch = false

    tags = {
        Name = "private_subnet-c"
    }
}

#インターネットゲートウェイ
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "main_igw"
    }
}

#ルートテーブル(踏み台_SSH)
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "public_rt"
    }
}

#ルートテーブル(プライベート)
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "private_rt"
    }
}

#ルートテーブルとサブネットの関連付け(パブリック)
resource "aws_route_table_association" "public"{
    subnet_id = aws_subnet.public_a.id
    route_table_id = aws_route_table.public.id
}

#ルートテーブルとサブネットの関連付け(プライベート)
resource "aws_route_table_association" "private" {
    for_each = {
        private_a = aws_subnet.private_a.id
        private_c = aws_subnet.private_c.id
    }

    subnet_id = each.value
    route_table_id = aws_route_table.private.id
}

#サブネットグループ(RDS)
resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "rds-subnet-group"
    subnet_ids = [
        aws_subnet.private_a.id,
        aws_subnet.private_c.id
    ]

    tags = {
        Name = "rds-subnet-group"
    }
}

#セキュリティグループ(踏み台)
resource "aws_security_group" "bastion_sg" {
    description = "Allow SSH and HTTP(S) from anyware"
    name = "bastion-sg"
    vpc_id = aws_vpc.main.id

    #SSH
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    #HTTP
    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    #HTTPS
    ingress {
        description = "HTTPS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    #全て許可
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "bastion-sg"
    }
}

#セキュリティグループ(RDS)
resource "aws_security_group" "rds_sg" {
    description = "Allow MySQL from Bastion"
    name = "rds-sg"
    vpc_id = aws_vpc.main.id

    #踏み台のみ許可
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.bastion_sg.id]
    }

    #全て許可
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "rds-sg"
    }
}

#RDS
resource "aws_db_instance" "mysql" {
    db_name                 = var.rds_config.db_name
    identifier              = var.rds_config.identifier
    instance_class          = var.rds_config.instance_class
    allocated_storage       = var.rds_config.allocated_storage
    engine                  = var.rds_config.engine
    engine_version          = var.rds_config.engine_version
    username                = var.rds_config.username
    password                = var.rds_config.password
    db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
    vpc_security_group_ids  = [aws_security_group.rds_sg.id]
    skip_final_snapshot     = true
    publicly_accessible     = false
    multi_az                = false
    availability_zone       = var.rds_config.availability_zone

    tags = {
        Name = "my-mysql-db"
    }
}

#踏み台EC2
resource "aws_instance" "bastion" {
    ami                         = var.ec2_config.ami
    instance_type               = var.ec2_config.instance_type
    subnet_id                   = aws_subnet.public_a.id
    key_name                    = var.ec2_config.key_name
    vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
    iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
    associate_public_ip_address = true

    #自動インストール
    user_data = <<-EOF
        #!/bin/bash
        yum update -y
        amazon-linux-extras enable php8.0
        yum install -y httpd php php-mysqlnd
        systemctl start httpd
        systemctl enable httpd

        cat <<EOT > /var/www/html/test.php
        ${data.template_file.php_test.rendered}
        EOT
    EOF

    tags = {
        Name = "bastion"
    }
}

data "template_file" "php_test" {
    template = file("test.php.tpl")

    vars = {
        db_endpoint = aws_db_instance.mysql.endpoint
        db_user     = var.rds_config.username
        db_pass     = var.rds_config.password
        db_name     = var.rds_config.db_name
    }
}