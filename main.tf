module "windows_admin_vpc" {
  source = "./vpc-module"

  az-number     = var.az-number
  vpc-cidr      = var.vpc-cidr
  newbits       = var.newbits
  subnet-number = var.subnet-number

}


locals {
  instances_with_user_data = {
  for key, val in var.instances :

  key => {
    os_ami         = val["os_ami"],
    type           = val["type"],
    user_data      = templatefile(val["user_data_path"], {
      ansible_user = var.ansible_user.user, ansible_pwd = var.ansible_user.pwd
    }),
    tag_name       = val["tag_name"],
    instance_count = val["instance_count"]
  }

  }
}


module "windows_ec2" {
  source = "./ec2-module"

  vpc-id    = module.windows_admin_vpc.vpc_id
  subnet-id = module.windows_admin_vpc.subnet_ids
  sg-rules  = var.windows-sg-rules
  key-name  = aws_key_pair.key.key_name
  instances = local.instances_with_user_data
  ami_map   = var.ami_map


  depends_on = [module.windows_admin_vpc, aws_key_pair.key]

}


resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "key" {
  content  = tls_private_key.key.private_key_pem
  filename = "files/win_key.pem"
}

resource "aws_key_pair" "key" {
  key_name   = "win-key"
  public_key = tls_private_key.key.public_key_openssh
}
