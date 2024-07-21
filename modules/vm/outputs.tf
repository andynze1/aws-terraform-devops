# output "vm_id" {
#   value = aws_instance.build-server.id
# }

output "build_server_ip" {
  description = "The IP of the Build Server."
  value       = aws_instance.build-server.public_ip
}

# output "aws_network_interface" {
#   description = "The Network Interface."
#   value       = aws_network_interface.public.id
# }

output "debug_security_group" {
  value = var.security_group_id
}

output "aws_instance_id" {
  value = aws_instance.build-server.id
}