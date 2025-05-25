data "aws_iam_policy_document" "assume_role_policy" {
    statement {
        effect  = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
} 

data "aws_iam_policy_document" "inline_policy" {
    statement {
        actions     = ["s3:ListBucket", "ec3:DescribeInstances", "ec2:DescribeSecurityGroups"]
        effect      = "Allow"
        resources   = ["*"]
    }
}