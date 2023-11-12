variable "name" {
  type    = string
  default = "KEN"
}

variable "versioning" {
  type    = string
  default = "Enabled"
}

variable "acl" {
  type    = string
  default = "private"
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "create_vpc" {
  type    = bool
  default = true
}