provider "aws"{
    region = "ap-northeast-1"
}

# VPC
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "main_vpc"
    }
}

# Public Subnet
resource "aws_subnet" "public" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = var.subnet_cidr
    availability_zone       = var.subnet_az
    map_public_ip_on_launch = true

    tags = {
        Name = "public_subnet"
    }
}

# インターネットゲートウェイ
resource "aws_internet_gateway""igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "main_igw"
    }
}

# ルートテーブル
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

# ルートテーブルの関連付け Public Subnet
resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

# セキュリティグループ EC2
resource "aws_security_group" "ec2_sg" {
    name = "ec2_sg"
    description = "Allow SSH from anywhere"
    vpc_id = aws_vpc.main.id

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ec2_sg"
    }
}

# EC2
resource "aws_instance" "web" {
    ami                         = var.ami_id
    instance_type               = var.instance_type
    subnet_id                   = aws_subnet.public.id
    key_name                    = var.key_name
    vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
    associate_public_ip_address = true #ここつまった

    tags = {
        Name = "web_server"
    }
}

