resource "aws_acm_certificate" "observability_certificate" {
  domain_name       = "*.${var.zone_name}"
  validation_method = "DNS"
}

resource "aws_route53_zone" "observability_dns" {
  name = var.zone_name

  tags = {
    Name        = "${var.project}-${var.environment}-observability-dns"
    Team        = "acloud"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

resource "aws_route53_record" "grafana_dns" {
  zone_id = aws_route53_zone.observability_dns.zone_id
  name    = "${var.project}-grafana"
  type    = "A"

  alias {
    name                   = var.grafana_dns_name
    zone_id                = var.grafana_lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "prometheus_dns" {
  zone_id = aws_route53_zone.observability_dns.zone_id
  name    = "${var.project}-prometheus"
  type    = "A"

  alias {
    name                   = var.prometheus_dns_name
    zone_id                = var.prometheus_lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "opensearch_dns" {
  zone_id = aws_route53_zone.observability_dns.zone_id
  name    = "${var.project}-opensearch"
  type    = "A"

  alias {
    name                   = var.opensearch_dns_name
    zone_id                = var.nodeexporter_lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "nodeexporter_dns" {
  zone_id = aws_route53_zone.observability_dns.zone_id
  name    = "${var.project}-nodeexporter"
  type    = "A"

  alias {
    name                   = var.nodeexporter_dns_name
    zone_id                = var.opensearch_lb_zone_id
    evaluate_target_health = true
  }
}
