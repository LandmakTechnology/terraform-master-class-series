variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "create_igw" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them."
  type        = bool
  default     = true
}

variable "create_nat_gw" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them."
  type        = bool
  default     = true
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = any
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = any
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_cidr" {
  description = "A list of private subnets inside the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azones" {
  description = "A list of azs"
  type        = any
  default     = ["us-east-1a", "us-east-1b"]
}