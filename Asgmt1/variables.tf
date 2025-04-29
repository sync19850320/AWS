#########################################
# 変数定義
#########################################

#リージョン
variable "aws_region"{
    description = "AWS region"
    default     = "ap-northeast-1"
}

# VPC CIDR
variable "vpc_cidr"{
    description = "CIDR block for the VPC"
    default     = "10.0.0.0/16"
}

# Public Subnet CIDR
variable "subnet_cidr"{
    description = "CIDR block for the public subnet"
    default     = "10.0.1.0/24"
}

# Public Subnet AZ
variable "subnet_az"{
    description = "AZ for the public subnet"
    default     = "ap-northeast-1a"
}

# AMI ID(AmazonLinux 2)
variable "ami_id"{
    description = "AMI ID for EC2 instance"
    default     = "ami-0d921a0e79f9f6e6e"
}

# インスタンスタイプ
variable "instance_type"{
    description = "EC2 instance type"
    default     = "t2.micro"
}

# キーペア
variable "key_name" {
    description = "SSH key pair"
    default     = "20250429_ssh" # 拡張子(.pem)を入れたことでエラー
}