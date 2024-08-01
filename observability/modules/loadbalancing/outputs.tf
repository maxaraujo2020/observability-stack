# --- loadbalancing/outputs.tf ---
output "grafana_tg_arn" {
  value = aws_lb_target_group.grafana_tg.arn
}

output "prometheus_tg_arn" {
  value = aws_lb_target_group.prometheus_tg.arn
}

# output "nodeexporter_tg_arn" {
#   value = aws_lb_target_group.nodeexporter_tg.arn
# }

# output "opensearch_tg_arn" {
#   value = aws_lb_target_group.opensearch_tg.arn
# }

output "grafana_url" {
  value = aws_lb.loadbalancer_grafana.dns_name
}

output "prometheus_url" {
  value = aws_lb.loadbalancer_prometheus.dns_name
}

# output "nodeexporter_url" {
#   value = aws_lb.loadbalancer_nodeexporter.dns_name
# }

# output "opensearch_url" {
#   value = aws_lb.loadbalancer_opensearch.dns_name
# }

output "grafana_zoneid" {
  value = aws_lb.loadbalancer_grafana.zone_id
}

output "prometheus_zoneid" {
  value = aws_lb.loadbalancer_grafana.zone_id
}

output "nodeexporter_zoneid" {
  value = aws_lb.loadbalancer_grafana.zone_id
}

output "opensearch_zoneid" {
  value = aws_lb.loadbalancer_grafana.zone_id
}


