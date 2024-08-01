# variable "url_ecr_grafana" {}
# variable "url_ecr_prometheus" {}
# variable "url_ecr_alertmanager" {}
# variable "url_ecr_opensearch" {}
variable "subnets" {}
variable "vpc_id" {}
variable "environment" {}
variable "project" {}
variable "region" {}
# variable "security_groups_ecs" {}
variable "grafana_service_tg_arn" {}
variable "prometheus_service_tg_arn" {}
variable "nodeexporter_service_tg_arn" {}
variable "opensearch_service_tg_arn" {}
variable "vpc_cidr" {}
variable "ecs_subnets" {}
variable "security_groups_alb" {}