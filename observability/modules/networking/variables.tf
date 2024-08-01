# --- modules/networking/variables.tf ---

variable "vpc_cidr" {
  type = string
}

variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "public_cidrs" {
  type = list(any)
}

variable "private_cidrs" {
  type = list(any)
}

variable "public_sn_count" {
  type = number
}

variable "private_sn_count" {
  type = number
}

variable "max_subnets" {
  type = number
}
