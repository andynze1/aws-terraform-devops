locals {
  env = terraform.workspace
}

module "network" {
  source               = "./modules/network"
  aws_region           = var.aws_region
  vpc_id               = var.vpc.id
  my_ip_address        = var.my_ip_address
  aws_instance_id      = var.aws_instance_id
  public_subnet_id     = var.public_subnet_id
  network_interface_id = var.network_interface_id
}

module "vm" {
  aws_region           = var.aws_region
  source               = "./modules/vm"
  instance_type        = "t2.large"
  public_key_path      = var.public_key_path
  volume_size          = var.volume_size
  ami_id_ubuntu        = var.ami_id_ubuntu
  private_subnet_id    = module.network.private_subnet_id
  public_subnet_id     = module.network.public_subnet_id
  vpc_id               = module.network.vpc_id
  security_group_id    = module.network.security_group_id
  aws_instance_id      = var.aws_instance_id
  network_interface_id     = module.network.public_network_interface_id
}

