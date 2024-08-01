# --- root/locals.tf ---
locals {
  vpc_cidr = "192.168.0.0/18"
}

locals {
  security_groups_alb = {
    public = {
      name        = "${module.networking.project_name}-${module.networking.env}-alb-sg"
      description = "Security Group for Observability Load Balancer"
      ingress = {
        http = {
          description = "Security Group used to application"
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        https = {
          description = "Security Group used to application/security"
          from        = 443
          to          = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }
}