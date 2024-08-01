
resource "aws_security_group" "lb_sg" {
  name        = "${var.project}-${var.environment}-lb-sg"
  vpc_id      = var.vpc_id
  description = "Security Group for Public Access"

  ingress {
    description = "Security Group used to Application"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Security Group used to Application"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# Grafana
resource "aws_lb" "loadbalancer_grafana" {
  name               = "grafana-${var.environment}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnets.*

  enable_deletion_protection = false

  tags = {
    Name        = "grafana-${var.project}-${var.environment}-lb"
    Team        = "acloud"
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}

resource "aws_lb_target_group" "grafana_tg" {
  name        = "${var.environment}-grafana-tg"
  port        = var.tg_port_grafana
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 4
    interval            = 50
    protocol            = "HTTP"
    timeout             = 5
    path                = "/api/health"
    unhealthy_threshold = 4
  }

  tags = {
    Name        = "${var.project}-${var.environment}-grafana-tg"
    Team        = "acloud"
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}

resource "aws_lb_listener" "grafana_listener" {
  load_balancer_arn = aws_lb.loadbalancer_grafana.arn
  port              = "80"
  protocol          = "HTTP"

  # port              = "443"
  # protocol          = "HTTPS"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = var.eu-west-1_certificate

  default_action {
    target_group_arn = aws_lb_target_group.grafana_tg.arn
    type             = "forward"
  }

  tags = {
    Name        = "${var.project}-${var.environment}-grafana-listener"
    Team        = "acloud"
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}


# Prometheus
resource "aws_lb" "loadbalancer_prometheus" {
  name               = "prometheus-${var.environment}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnets.*

  enable_deletion_protection = false

  tags = {
    Name        = "prometheus-${var.project}-${var.environment}-lb"
    Team        = "acloud"
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}

resource "aws_lb_target_group" "prometheus_tg" {
  name        = "${var.environment}-prometheus-tg"
  port        = var.tg_port_prometheus
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"


  health_check {
    healthy_threshold   = 4
    interval            = 30
    protocol            = "HTTP"
    timeout             = 5
    path                = "/health"
    unhealthy_threshold = 4
  }

  tags = {
    Name        = "${var.project}-${var.environment}-prometheus-tg"
    Team        = "acloud"
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}

resource "aws_lb_listener" "prometheus_listener" {
  load_balancer_arn = aws_lb.loadbalancer_prometheus.arn
  port              = "80"
  protocol          = "HTTP"

  # port              = "443"
  # protocol          = "HTTPS"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = var.eu-west-1_certificate

  default_action {
    target_group_arn = aws_lb_target_group.prometheus_tg.arn
    type             = "forward"
  }

  tags = {
    Name        = "${var.project}-${var.environment}-prometheus-listener"
    Team        = "acloud"
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}

# Node Exporter
# resource "aws_lb" "loadbalancer_nodeexporter" {
#   name               = "nodeexporter-${var.environment}-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.lb_sg.id]
#   subnets            = var.subnets.*

#   enable_deletion_protection = false

#   tags = {
#     Name        = "nodeexporter-${var.project}-${var.environment}-lb"
#     Team        = "acloud"
#     Project     = var.project
#     Environment = var.environment
#     Region      = var.region
#   }
# }

# resource "aws_lb_target_group" "nodeexporter_tg" {
#   name        = "${var.environment}-nodeexporter-tg"
#   port        = var.tg_port_nodeexporter
#   protocol    = "HTTP"
#   vpc_id      = var.vpc_id
#   target_type = "instance"

#   health_check {
#     healthy_threshold   = 5
#     interval            = 30
#     protocol            = "HTTP"
#     timeout             = 5
#     path                = "/health"
#     unhealthy_threshold = 3
#   }

#   tags = {
#     Name        = "${var.project}-${var.environment}-nodeexporter-tg"
#     Team        = "acloud"
#     Project     = var.project
#     Environment = var.environment
#     Region      = var.region
#   }
# }

# resource "aws_lb_listener" "nodeexporter_listener" {
#   load_balancer_arn = aws_lb.loadbalancer_nodeexporter.arn
#   port              = "80"
#   protocol          = "HTTP"

#   # port              = "443"
#   # protocol          = "HTTPS"
#   # ssl_policy        = "ELBSecurityPolicy-2016-08"
#   # certificate_arn   = var.eu-west-1_certificate

#   default_action {
#     target_group_arn = aws_lb_target_group.nodeexporter_tg.arn
#     type             = "forward"
#   }

#   tags = {
#     Name        = "${var.project}-${var.environment}-nodeexporter-listener"
#     Team        = "acloud"
#     Project     = var.project
#     Environment = var.environment
#     Region      = var.region
#   }
# }


# Alertmanager
resource "aws_lb" "loadbalancer_alertmanager" {
  name               = "alertmanager-${var.environment}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnets.*

  enable_deletion_protection = false

  tags = {
    Name        = "alertmanager-${var.project}-${var.environment}-lb"
    Team        = "acloud"
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}

resource "aws_lb_target_group" "alertmanager_tg" {
  name        = "${var.environment}-alertmanager-tg"
  port        = var.tg_port_alertmanager
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 4
    interval            = 50
    protocol            = "HTTP"
    timeout             = 5
    path                = "/-/healthy"
    unhealthy_threshold = 4
  }

  tags = {
    Name        = "${var.project}-${var.environment}-alertmanager-tg"
    Team        = "acloud"
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}

resource "aws_lb_listener" "alertmanager_listener" {
  load_balancer_arn = aws_lb.loadbalancer_alertmanager.arn
  port              = "80"
  protocol          = "HTTP"

  # port              = "443"
  # protocol          = "HTTPS"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = var.eu-west-1_certificate

  default_action {
    target_group_arn = aws_lb_target_group.alertmanager_tg.arn
    type             = "forward"
  }

  tags = {
    Name        = "${var.project}-${var.environment}-alertmanager-listener"
    Team        = "acloud"
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}

# Kibana
resource "aws_lb" "loadbalancer_kibana" {
  name               = "kibana-${var.environment}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnets.*

  enable_deletion_protection = false

  tags = {
    Name        = "kibana-${var.project}-${var.environment}-lb"
    Team        = "acloud"
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}

resource "aws_lb_target_group" "kibana_tg" {
  name        = "${var.environment}-kibana-tg"
  port        = var.tg_port_kibana
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 4
    interval            = 50
    protocol            = "HTTP"
    timeout             = 5
    path                = "/api/status"
    unhealthy_threshold = 4
  }

  tags = {
    Name        = "${var.project}-${var.environment}-kibana-tg"
    Team        = "acloud"
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}

resource "aws_lb_listener" "kibana_listener" {
  load_balancer_arn = aws_lb.loadbalancer_kibana.arn
  port              = "80"
  protocol          = "HTTP"

  # port              = "443"
  # protocol          = "HTTPS"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = var.eu-west-1_certificate

  default_action {
    target_group_arn = aws_lb_target_group.kibana_tg.arn
    type             = "forward"
  }

  tags = {
    Name        = "${var.project}-${var.environment}-kibana-listener"
    Team        = "acloud"
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}