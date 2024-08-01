

resource "aws_ecs_service" "grafana_service" {
  name            = "${var.project}-${var.environment}-ecs-grafana-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.grafana_task_definition.arn
  desired_count   = 1

  # network_configuration {
  #   subnets         = [
  #     var.ecs_subnets[0],
  #     var.ecs_subnets[1]
  #   ]
  #   security_groups = [aws_security_group.autoscaling_sg.id]
  # }

  force_new_deployment = true
  placement_constraints {
    type = "distinctInstance"
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = var.grafana_service_tg_arn
    container_name   = "grafana-container"
    container_port   = 3000
  }

  depends_on = [aws_autoscaling_group.ecs_autoscaling_group]
}

resource "aws_ecs_service" "prometheus_service" {
  name            = "${var.project}-${var.environment}-ecs-prometheus-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.prometheus_task_definition.arn
  desired_count   = 1

  # network_configuration {
  #   subnets         = [
  #     var.ecs_subnets[0],
  #     var.ecs_subnets[1]
  #   ]
  #   security_groups = [aws_security_group.autoscaling_sg.id]
  # }

  force_new_deployment = true
  placement_constraints {
    type = "distinctInstance"
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = var.prometheus_service_tg_arn
    container_name   = "prometheus-container"
    container_port   = 9090
  }

  depends_on = [aws_autoscaling_group.ecs_autoscaling_group]
}

resource "aws_ecs_service" "nodeexporter_service" {
  name            = "${var.project}-${var.environment}-ecs-nodeexporter-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.nodeexporter_task_definition.arn
  desired_count   = 1

  # network_configuration {
  #   subnets         = [
  #     var.ecs_subnets[0],
  #     var.ecs_subnets[1]
  #   ]
  #   security_groups = [aws_security_group.autoscaling_sg.id]
  # }

  force_new_deployment = true
  placement_constraints {
    type = "distinctInstance"
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = var.nodeexporter_service_tg_arn
    container_name   = "nodeexporter-container"
    container_port   = 9100
  }

  depends_on = [aws_autoscaling_group.ecs_autoscaling_group]
}

resource "aws_ecs_service" "opensearch_service" {
  name            = "${var.project}-${var.environment}-ecs-opensearch-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.opensearch_task_definition.arn
  desired_count   = 1

  # network_configuration {
  #   subnets         = [
  #     var.ecs_subnets[0],
  #     var.ecs_subnets[1]
  #   ]
  #   security_groups = [aws_security_group.autoscaling_sg.id]
  # }

  force_new_deployment = true
  placement_constraints {
    type = "distinctInstance"
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
    weight            = 100
  }

  load_balancer {
    target_group_arn = var.opensearch_service_tg_arn
    container_name   = "opensearch-container"
    container_port   = 5601
  }

  depends_on = [aws_autoscaling_group.ecs_autoscaling_group]
}

