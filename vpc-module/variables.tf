variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  default = "us-east-1"
}
variable "az-number" {
  type    = number
}
variable "vpc-cidr" {
  type = string
}
variable "newbits" {
  type        = number
  description = "Look at the terraform function cidrsubnet, newbits is the second parameter"
}

variable "subnet-number" {
  type = number
}





