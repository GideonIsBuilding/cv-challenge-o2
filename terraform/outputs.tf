output "public_ip" {
    description = "Public IP of the EC2 instance"
    value = data.aws_eip.dojo-eip.public_ip
}

output "subnet_id" {
    description = "Subnet ID for the EC2 instance"
    value       = aws_subnet.dojo-subnet.id
}

output "security_group_id" {
    description = "Security group ID used by the instance"
    value       = aws_security_group.app_security.id
}
