variable "vpc-id" {
  type = string
}

variable "subnet-id" {
  type = list(string)
}
variable "ami" {
}

variable "sg-rules" {
  type = map(object({
    type                     = string,
    from_port                = number,
    to_port                  = number,
    protocol                 = string,
    source_security_group_id = string,
    source_cidr_ip           = list(string)
  }))
  default = {}
}


variable "instances" {
  type = map(object({
    type           = string,
    tag_name       = string
    instance_count = number
  }))
}

variable "key-name" {
  type = string
}
