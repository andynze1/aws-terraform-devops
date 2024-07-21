variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The type of instance to be created"
  type        = string
  default     = "t2.large"
}

variable "vpc" {
  description = "The VPC configuration"
  type = object({
    id                 = string
    cidr_block         = string
    availability_zones = list(string)
  })
  default = {
    id                 = "vpc-vpc.id"
    cidr_block         = "10.0.0.0/16"
    availability_zones = ["us-east-1a", "us-east-1b"]
  }
}

variable "my_ip_address" {
  description = "Your IP address with a /32 subnet mask"
  type        = string
  default     = "146.85.136.78/32"
}

variable "public_key_path" {
  description = "The path to the public key"
  type        = string
  default     = "./default-public-key.pub"
}

variable "ami_id_ubuntu" {
  description = "Ubuntu Server 22.04 LTS (HVM),EBS General Purpose (SSD) Volume Type."
  type        = string
  default     = "ami-0a0e5d9c7acc336f1"
}

variable "volume_size" {
  description = "The VM size"
  type        = string
  default     = "30"
}

variable "network_interface_id" {
  description = "The ID of the network interface to attach to the instance"
  type        = string
  default = "aws_network_interface.public.id"
}

variable "aws_instance_id" {
  description = "This defines the Ubuntu Linux ID"
  type        = string
  default     = "aws_instance.build-server.id"
}

variable "public_subnet_id" {
  description = "This defines Public Subnet ID"
  type        = string
  default     = "aws_subnet.public_subnet.id"
}