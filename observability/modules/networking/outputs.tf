# --- modules/networking/output.tf ---

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc_network.id
}

output "vpc_cidr" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc_network.cidr_block
}

output "all_public_subnets" {
  description = "All the public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "all_private_subnets" {
  description = "All the private subnets"
  value       = aws_subnet.private_subnet[*].id
}

output "nat_gtw_public_ip" {
  description = "The Elastic IP address associated with the NAT Gateway"
  value       = aws_nat_gateway.nat_gateway[*].public_ip
}

output "project_name" {
  value = aws_vpc.vpc_network.tags.Project
}

output "env" {
  value = aws_vpc.vpc_network.tags.Environment
}

output "region" {
  value = aws_vpc.vpc_network.tags.Region
}