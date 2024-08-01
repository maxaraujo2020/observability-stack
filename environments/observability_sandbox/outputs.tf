output "ec2_instance_ids" {
  description = "List of EC2 instances"
  value       = data.aws_instances.all_ec2_instances.ids
}

output "rds_instance_arns" {
  description = "List of RDS instances"
  value       = data.aws_db_instances.all_rds_instances.instance_arns
}

output "eks_cluster_names" {
  description = "List of EKS instances"
  value       = data.aws_eks_clusters.all_eks_clusters.names
}

# output "grafana_dnsname" {
#   description = "Grafana - DNS Name"
#   value       = module.loadbalancing.grafana_url
# }

# output "prometheus_dnsname" {
#   description = "Grafana - DNS Name"
#   value       = module.loadbalancing.prometheus_url
# }

# output "opensearch_dnsname" {
#   description = "Grafana - DNS Name"
#   value       = module.loadbalancing.opensearch_url
# }

# output "nodeexporter_dnsname" {
#   description = "Grafana - DNS Name"
#   value       = module.loadbalancing.nodeexporter_url
# }

# output "grafana_main_url" {
#   value = module.dns.grafana_main_url
# }

# output "prometheus_main_url" {
#   value = module.dns.prometheus_main_url
# }

# output "nodeexporter_main_url" {
#   value = module.dns.nodeexporter_main_url
# }

# output "opensearch_main_url" {
#   value = module.dns.opensearch_main_url
# }
