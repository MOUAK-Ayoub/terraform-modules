variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "region" {
  default = "us-east-1"
}

variable "az-number" {
  type    = number
  default = 2
}

variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

variable "newbits" {
  type        = number
  default     = 8
  description = "Look at the terraform function cidrsubnet, newbits is the second parameter"
}

variable "subnet-number" {
  type    = number
  default = 3
}

variable "windows-ami" {
  default = "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-Base"
}


variable "instances" {
  type = map(object({
    type           = string,
    tag_name       = string
    instance_count = number
  }))
  default = {
    "master" = {
      type     = "t3.medium"
      tag_name = "Domain Controller"
      instance_count    = 1
    },
    "slave" = {
      type           = "t3.small"
      tag_name       = "laptop"
      instance_count = 2
    }
  }
}


variable "windows-sg-rules" {
  type = map(object({
    type                     = string,
    from_port                = number,
    to_port                  = number,
    protocol                 = string,
    source_security_group_id = string,
    source_cidr_ip           = list(string)
  }))
  default = {
    "allow_rdp" = {
      type                     = "ingress"
      from_port                = 3389
      to_port                  = 3389,
      protocol                 = "tcp",
      source_security_group_id = null,
      source_cidr_ip           = ["0.0.0.0/0"]

    }, "allow_all_from_same_sg" = {
      type                     = "ingress"
      from_port                = 0
      to_port                  = 0,
      protocol                 = "-1",
      source_security_group_id = "sg",
      source_cidr_ip           = null

    }, "allow_all_egress" = {
      type                     = "egress"
      from_port                = 0
      to_port                  = 0,
      protocol                 = "-1",
      source_security_group_id = null,
      source_cidr_ip           = ["0.0.0.0/0"]
    }
  }
}



