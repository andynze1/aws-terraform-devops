output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public_subnet : s.id]
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private_subnet : s.id]
}

output "public_network_interface_ids" {
  value = [for ni in aws_network_interface.public : ni.id]
}

output "security_group_id" {
  value = aws_security_group.cluster.id
}