data "aws_caller_identity" "current" {}

module "networking" {
  source           = "../../observability/modules/networking"
  vpc_cidr         = local.vpc_cidr
  public_sn_count  = 2
  private_sn_count = 2
  max_subnets      = 4
  project          = "shared"
  region           = "eu-west-1"
  environment      = "observability"
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
}

# module "containers" {
#   source  = "../../observability/modules/containers"
#   subnets = module.networking.all_public_subnets
#   vpc_id  = module.networking.vpc_id
#   # security_groups_ecs = local.security_groups_ecs
#   security_groups_alb         = local.security_groups_alb
#   grafana_service_tg_arn      = module.loadbalancing.grafana_tg_arn
#   prometheus_service_tg_arn   = module.loadbalancing.prometheus_tg_arn
#   nodeexporter_service_tg_arn = module.loadbalancing.nodeexporter_tg_arn
#   opensearch_service_tg_arn   = module.loadbalancing.opensearch_tg_arn
#   project                     = module.networking.project_name
#   environment                 = module.networking.env
#   region                      = module.networking.region
#   ecs_subnets                 = module.networking.all_private_subnets
#   vpc_cidr                    = local.vpc_cidr
# }

module "repository" {
  source      = "../../observability/modules/repository"
  project     = module.networking.project_name
  environment = module.networking.env
  region      = module.networking.region
}

module "storage" {
  source      = "../../observability/modules/storage"
  subnets     = module.networking.all_private_subnets
  vpc_id      = module.networking.vpc_id
  vpc_cidr    = module.networking.vpc_cidr
  project     = module.networking.project_name
  environment = module.networking.env
  region      = module.networking.region
}

module "loadbalancing" {
  source               = "../../observability/modules/loadbalancing"
  subnets              = module.networking.all_public_subnets
  vpc_id               = module.networking.vpc_id
  tg_port_grafana      = 3000
  tg_port_prometheus   = 9090
  tg_port_nodeexporter = 9100
  tg_port_alertmanager = 9093
  tg_port_kibana       = 5601
  project              = module.networking.project_name
  environment          = module.networking.env
  region               = module.networking.region
}

# module "dns" {
#   source                  = "../../observability/modules/dns"
#   zone_name               = "devoteam-acloud.com"
#   grafana_dns_name        = module.loadbalancing.grafana_url
#   prometheus_dns_name     = module.loadbalancing.prometheus_url
#   opensearch_dns_name     = module.loadbalancing.opensearch_url
#   nodeexporter_dns_name   = module.loadbalancing.nodeexporter_url
#   grafana_lb_zone_id      = module.loadbalancing.grafana_zoneid
#   prometheus_lb_zone_id   = module.loadbalancing.prometheus_zoneid
#   nodeexporter_lb_zone_id = module.loadbalancing.nodeexporter_zoneid
#   opensearch_lb_zone_id   = module.loadbalancing.opensearch_zoneid
#   project                 = module.networking.project_name
#   environment             = module.networking.env
#   region                  = module.networking.region
# }

module "bucket" {
  source      = "../../observability/modules/bucket"
  project     = module.networking.project_name
  environment = module.networking.env
  region      = module.networking.region
}
