locals {
  cidr_blocks = {
    stage = "10.0.0.0/16"
    prod  = "10.1.0.0/16"
    default = "10.2.0.0/16"  # Add this line if you are using the default workspace
  }
  public_subnet_cidr = {
    stage = "10.0.1.0/24"
    prod  = "10.1.1.0/24"
  }
  private_subnet_cidr = {
    stage = "10.0.2.0/24"
    prod  = "10.1.2.0/24"
  }
  availability_zones = {
    stage = ["us-east-1a", "us-east-1b"]
    prod  = ["us-east-1a", "us-east-1b"]
  }
  security_group_rules = [
    {
      name        = "SSH access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.my_ip_address]
    },
    {
      name        = "HTTP access"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      name        = "Application 8081 access"
      from_port   = 8081
      to_port     = 8081
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      name        = "Application 8080 access"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      name        = "Application 9000 access"
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
