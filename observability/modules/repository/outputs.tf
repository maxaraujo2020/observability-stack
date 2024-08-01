# --- modules/networking/output.tf ---

output "ecr_image_grafana" {
  value = aws_ecr_repository.grafana_repository.repository_url
}

output "ecr_image_prometheus" {
  value = aws_ecr_repository.prometheus_repository.repository_url
}

# output "ecr_image_alertmanager" {
#   value = aws_ecr_repository.alertmanager_repository.repository_url
# }

# output "ecr_image_opensearch" {
#   value = aws_ecr_repository.opensearch_repository.repository_url
# }