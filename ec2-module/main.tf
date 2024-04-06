data "aws_ami" "ami" {
  for_each =  var.ami_map

  most_recent = true
  filter {
    name   = "name"
    values = [each.value]
  }
}

locals {
  instances_flat = merge([
  for key, val in var.instances :
  {
  for idx in range(val["instance_count"]) :

  "${key}-${idx}" =>{

      os_ami         = val["os_ami"],
      type           = val["type"],
      user_data      = val["user_data"],
      tag_name       = val["tag_name"],
      instance_count = val["instance_count"]
  }
  }
  ]...)
}

resource "aws_instance" "instance" {

  for_each      = local.instances_flat
  ami           = data.aws_ami.ami[each.value.os_ami].id
  instance_type = each.value.type
  key_name      = var.key-name
  user_data = each.value.user_data

  vpc_security_group_ids = [
    aws_security_group.security_group.id
  ]
  subnet_id = var.subnet-id[index(keys(local.instances_flat), each.key) % length(var.subnet-id)]


  associate_public_ip_address = true
  tags                        = {
    Name = each.value.tag_name
  }
    depends_on = [aws_security_group.security_group, data.aws_ami.ami]


}


resource "aws_security_group" "security_group" {
  vpc_id = var.vpc-id

}

resource "aws_security_group_rule" "allow_inbound_windows_rdp" {

  for_each          = var.sg-rules
  security_group_id = aws_security_group.security_group.id

  type                     = each.value.type
  cidr_blocks              = each.value.source_cidr_ip != null ? each.value.source_cidr_ip : null
  source_security_group_id = each.value.source_security_group_id != null ? aws_security_group.security_group.id : null
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  description              = each.key

}
