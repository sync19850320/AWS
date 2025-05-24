output "bastion_public_ip" {
    value = module.ec2.bastion_public_ip
}

output "bastion_private_ip" {
    value = module.ec2.bastion_private_ip
}