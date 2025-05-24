variable "environment" {
    description = "Environment"
    type = string
}

variable "project_name" {
    description = "Project name"
    type = string
}

variable "ec2_policy_statements" {
    description = "IAM policy statements for EC2 instance"
    type = list(object({
        effect      = string
        actions     = list(string)
        resources   = list(string)
    }))
    default = [
        {
            effect      = "Allow"
            actions     = ["s3:ListBucket"]
            resources   = ["*"]
        },
        {
            effect      = "Allow"
            actions     = ["ec2:DescribeInstances","ec2:DescribeSecurityGroups"]
            resources   = ["*"]
        }
    ]
}