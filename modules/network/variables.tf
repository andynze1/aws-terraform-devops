variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
  default = "aws_vpc.vpc.id"
}
variable "my_ip_address" {
  description = "Your IP address with a /32 subnet mask"
  type        = string
  default     = "146.85.136.101/32"
}
variable "public_subnet_id" {
  description = "The ID of the public subnet"
  type = string
}
variable "public_subnet" {
  description = "The name of the public subnet"
  type = string
  default = "aws_subnet.public_subnet"
}
variable "security_group_id" {
  type = string
  default = "aws_security_group.main.id"
}

variable "aws_instance_id" {
  description = "This defines the Ubuntu Linux ID"
  type = string
}
variable "subnet_id" {
  type = string
  default = "aws_subnet.public_subnet.id"
}
variable "network_interface_id" {
  description = "This defines the Network Interface ID"
  type = string
}