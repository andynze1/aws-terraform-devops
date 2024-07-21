variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group"
  type        = string
}

variable "public_subnet_id" {
  description = "The ID of the public subnet"
  type        = string
}

variable "private_subnet_id" {
  description = "The ID of the private subnet"
  type        = string
}

variable "instance_type" {
  description = "The type of instance to be created"
  type        = string
}
variable "public_key_path" {
  description = "The path to the public key"
  type        = string
}

variable "volume_size" {
  description = "The name of the virtual machine"
  type        = string
}

variable "ami_id_ubuntu" {
  description = "AMI ID for Ubuntu instances."
  type = string
}
# variable "public_subnet" {
#   description = "The ID of the public subnet"
#   type        = string
# }

# variable "subnet_id" {
#   description = "The subnet ID"
#   type        = string
# }

variable "network_interface_id" {
  description = "This defines the instance ID"
  type = string
}
# variable "aws_network_interface" {
#   description = "The interface "
#   type = string
# }
variable "aws_instance_id" {
  description = "This defines the Ubuntu Linux ID"
  type = string
  default = "aws_instance.build-server.id"
}