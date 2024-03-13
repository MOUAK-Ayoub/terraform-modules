data "aws_ssm_parameter" "ami" {
  name = var.ami
}

locals {
  instances_flat = merge([
  for key, val in var.instances :
  {
    for idx in range(val["instance_count"]) :

     "${key}-${idx}" =>{
        type     = val["type"],
        tag_name = val["tag_name"]
    }
  }]...)
}

resource "aws_instance" "instance" {

  for_each      = local.instances_flat
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = each.value.type
  key_name      = var.key-name

  vpc_security_group_ids = [
    aws_security_group.security_group.id
  ]
  subnet_id =  var.subnet-id[index(keys(local.instances_flat), each.key) % length(var.subnet-id)]


  associate_public_ip_address = true
  tags                        = {
    Name = each.value.tag_name
  }


}


resource "aws_security_group" "security_group" {
  name   = "main_sg"
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
