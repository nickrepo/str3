variable "env" {
  type        = string
  description = "name of the env i.e. dev/prod/uat/test"
  default     = "dev"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "CIDR block for public subnet"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

