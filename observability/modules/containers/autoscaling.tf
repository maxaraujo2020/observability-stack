
resource "aws_security_group" "autoscaling_sg" {
  name        = "${var.project}-${var.environment}-autoscaling-sg"
  vpc_id      = var.vpc_id
  description = "Security Group for Public Access"

  ingress {
    description = "Security Group used to NodeExporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Security Group used to Prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Security Group used to EFS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Security Group used to Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Security Group used to OpenSearch"
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

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

# resource "aws_launch_configuration" "ecs_launch_config" {
#   image_id               = "ami-0dfdc165e7af15242"
#   iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
#   security_groups      = [aws_security_group.autoscaling_sg.id]
#   user_data = filebase64("${path.module}/ecs.sh")
#   instance_type          = "t3a.xlarge"
#   depends_on = [aws_ecs_cluster.ecs_cluster]
# }

# resource "aws_launch_template" "launch_template" {
#   name_prefix            = "observability_launch_template_ecs"
#   image_id               = "ami-0dfdc165e7af15242"
#   instance_type          = "t3a.xlarge"
#   vpc_security_group_ids = [aws_security_group.autoscaling_sg.id]

#   iam_instance_profile {
#     arn = "arn:aws:iam::300012770768:instance-profile/ecsInstanceRole"
#   }

#   tag_specifications {
#     resource_type = "instance"

#   tags = {
#      Name = "ecs-instance"
#    }
#   }

#   user_data = filebase64("${path.module}/ecs.sh")

#   depends_on = [aws_ecs_cluster.ecs_cluster]
# }

# resource "aws_autoscaling_group" "ecs_autoscaling_group" {
#   name                = "${var.environment}-ecs-asg"
#   vpc_zone_identifier = [
#     var.ecs_subnets[0],
#     var.ecs_subnets[1]
#   ]
#   health_check_type         = "EC2"
#   desired_capacity    = 1
#   max_size            = 1
#   min_size            = 1

#   launch_configuration = aws_launch_configuration.ecs_launch_config.name

# launch_template {
#   id = aws_launch_configuration.ecs_launch_config.id
#   version = "$Latest"
# }

#   tag {
#     key                 = "AmazonECSManaged"
#     value               = true
#     propagate_at_launch = true
#   }

#   depends_on = [aws_ecs_cluster.ecs_cluster]
# }

# resource "aws_ecs_capacity_provider" "capacity_provider" {
#   name = "${var.environment}-ecs-capacity-provider"

#   auto_scaling_group_provider {
#     auto_scaling_group_arn = aws_autoscaling_group.ecs_autoscaling_group.arn

#     managed_scaling {
#       maximum_scaling_step_size = 2
#       minimum_scaling_step_size = 1
#       status                    = "ENABLED"
#       target_capacity           = 100
#       instance_warmup_period    = 60
#     }
#   }
# }

# resource "aws_ecs_cluster_capacity_providers" "ecs" {
#   cluster_name       = aws_ecs_cluster.ecs_cluster.name
#   capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]

#   default_capacity_provider_strategy {
#     base              = 1
#     weight            = 100
#     capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
#   }  

#   depends_on = [aws_ecs_cluster.ecs_cluster]
# }
