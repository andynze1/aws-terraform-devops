resource "aws_instance" "build-server" {
  ami           = var.ami_id_ubuntu
  instance_type = var.instance_type
  associate_public_ip_address = true
  key_name      = "${terraform.workspace}-keypair"
  vpc_security_group_ids = [var.security_group_id]
  subnet_id     = var.public_subnet_id
  
  user_data   = file("${path.module}/app-scripts/install.sh")
  tags = {
    Name =  "${terraform.workspace}-build-server"
  }
  
  root_block_device {
    volume_size = 40
    volume_type           = "gp2"
    delete_on_termination = true
  }
  depends_on = [ local_file.linux-pem-key ]
}

# resource "aws_network_interface_attachment" "public" {
#   instance_id           = aws_instance.build-server.id
#   network_interface_id  = var.network_interface_id
#   device_index          = 0
# }

resource "aws_key_pair" "key-pair" {
  key_name   = "${terraform.workspace}-keypair"
  public_key = tls_private_key.linux-keypair.public_key_openssh
}

resource "tls_private_key" "linux-keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "linux-pem-key" {
  content         = tls_private_key.linux-keypair.private_key_pem
  filename        = "${terraform.workspace}-keypair.pem"
  file_permission = "0400"
  depends_on      = [tls_private_key.linux-keypair]
}

