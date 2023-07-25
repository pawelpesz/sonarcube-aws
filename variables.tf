variable "region" {
  description = "AWS region"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "db_instance_size" {
  description = "DB instance size"
  type        = string
}

variable "db_instance_number" {
  description = "Number of DB instances"
  type        = number
}
