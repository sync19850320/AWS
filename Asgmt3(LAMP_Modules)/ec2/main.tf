resource "aws_instance" "bastion" {
    ami             = var.bastion.ami
    instance_type   = var.bastion.instance_type
    key_name        = var.bastion.key_name

    subnet_id = var.public_subnet_id
    vpc_security_group_ids = [var.bastion_sg_id]
    associate_public_ip_address = true

    iam_instance_profile = var.iam_instance_profile

    user_data = <<-EOF
        #!/bin/bash
        yum update -y
        amazon-linux-extras enable php8.0
        yum install -y mysql
        yum install -y httpd php php-mysqlnd
        systemctl start httpd
        systemctl enable httpd
        EOT
    EOF
    tags = {
        Name = "${var.environment}-${var.project_name}-bastion"
        Environment = var.environment
    }
}