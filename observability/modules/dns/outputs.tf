output "grafana_main_url" {
  value = "${aws_route53_record.grafana_dns.name}.${aws_route53_zone.observability_dns.name}"
}

output "prometheus_main_url" {
  value = "${aws_route53_record.prometheus_dns.name}.${aws_route53_zone.observability_dns.name}"
}

output "nodeexporter_main_url" {
  value = "${aws_route53_record.nodeexporter_dns.name}.${aws_route53_zone.observability_dns.name}"
}

output "opensearch_main_url" {
  value = "${aws_route53_record.opensearch_dns.name}.${aws_route53_zone.observability_dns.name}"
}