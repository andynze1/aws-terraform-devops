output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}
output "public_network_interface_id" {
  value = aws_network_interface.public.id
}
output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}
output "security_group_id" {
  value = aws_security_group.main.id
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "subnet_id" {
  value = aws_subnet.public_subnet.id
}
output "public_subnet" {
  value = aws_subnet.public_subnet
}