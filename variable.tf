variable "access_key" {}
variable "secret_key" {}

variable "keyname" {
  default = "ubuntu"
}

variable "region" {
  default = "us-west-2"
}

variable "ami" {
  default = "ami-5e63d13e"
}

variable "instance" {
  default = "t2.micro"
}

variable "tdssh" {
  default = "141.206.246.10/32"
}

variable "homessh" {
  default = "76.93.183.101/32"
}

variable "logpath" {
  default = "/var/log/tdcustom/accesslogs"
}

variable "webserverport" {
  default = 8900
}