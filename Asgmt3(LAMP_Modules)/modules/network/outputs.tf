output "vpc_id" {
    value = aws_vpc.this.id
}

output "public_subnet_ids" {
    value = {
        for k, v in aws_subnet.this : k => v.id
        if v.tags["Type"] == "public"
    }
}

output "private_subnet_ids" {
    value = {
        for k, v in aws_subnet.this : k => v.id
        if v.tags["Type"] == "private"
    }
}

output "security_group_ids" {
    value = {
        for k, v in aws_security_group.this : k => v.id
    }
}

output "db_subnet_group_name" {
    value = aws_db_subnet_group.this.name
}