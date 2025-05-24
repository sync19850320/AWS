#IAMロール(EC2)
resource "aws_iam_role" "ec2_role" {
    name = "ec2_role"
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
        Name = "ec2-role"
    }
}

#IAMポリシー(EC2)
resource "aws_iam_policy" "ec2_policy" {
    description = "Policy for EC2 instance"
    name = "ec2_policy"
    policy = jsonencode ({
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

#ポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
    policy_arn = aws_iam_policy.ec2_policy.arn
    role = aws_iam_role.ec2_role.name
}

#EC2にロールをアタッチ
resource "aws_iam_instance_profile" "ec2_instance_profile" {
    name = "my-ec2-instance-profile"
    role = aws_iam_role.ec2_role.name
}