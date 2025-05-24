resource "aws_iam_role" "ec2_role" {
    name = "${var.environment}-${var.project_name}-ec2-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            },
        ]
    })
    tags = {
        Name = "${var.environment}-${var.project_name}-ec2-role"
        Environment = var.environment
        Project = var.project_name
    }
}

resource "aws_iam_policy" "ec2_policy" {
    description = "Policy for EC2 instance"
    name = "${var.environment}-${var.project_name}-ec2-policy"
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "s3:ListBucket"
                Effect = "Allow"
                Resource = "*"
            },
            {
                Action = "ec2:DescribeInstances"
                Effect = "Allow"
                Resource = "*"
            },
            {
                Action = "ec2:DescribeSecurityGroups"
                Effect = "Allow"
                Resource = "*"
            },
        ]
    })
}

resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
    policy_arn = aws_iam_policy.ec2_policy.arn
    role = aws_iam_role.ec2_role.name
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
    name = "${var.environment}-${var.project_name}-ec2-profile"
    role = aws_iam_role.ec2_role.name
}