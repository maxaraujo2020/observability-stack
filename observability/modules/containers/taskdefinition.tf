resource "aws_ecs_task_definition" "grafana_task_definition" {
  family             = "grafana-family"
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  network_mode       = "bridge"
  cpu                = 512
  memory             = 1024
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = "grafana-container"
      image     = "grafana/grafana:latest"
      cpu       = 512
      memory    = 1024
      essential = true

      portMappings = [
        {
          name          = "grafana-tcp",
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp",
          appProtocol   = "http"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-create-group  = "true",
          awslogs-group         = "/ecs/grafana-service",
          awslogs-region        = "eu-west-1",
          awslogs-stream-prefix = "grafana-service"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "prometheus_task_definition" {
  family             = "prometheus-family"
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  network_mode       = "bridge"
  cpu                = 512
  memory             = 1024
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = "prometheus-container"
      image     = "bitnami/prometheus:latest"
      cpu       = 512
      memory    = 1024
      essential = true

      portMappings = [
        {
          name          = "prometheus-tcp",
          containerPort = 9090
          hostPort      = 9090
          protocol      = "tcp",
          appProtocol   = "http"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-create-group  = "true",
          awslogs-group         = "/ecs/prometheus-service",
          awslogs-region        = "eu-west-1",
          awslogs-stream-prefix = "prometheus-service"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "nodeexporter_task_definition" {
  family             = "nodeexporter-family"
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  network_mode       = "bridge"
  cpu                = 256
  memory             = 512
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = "nodeexporter-container"
      image     = "bitnami/node-exporter:latest"
      cpu       = 256
      memory    = 512
      essential = true

      portMappings = [
        {
          name          = "nodeexporter-tcp",
          containerPort = 9100
          hostPort      = 9100
          protocol      = "tcp",
          appProtocol   = "http"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-create-group  = "true",
          awslogs-group         = "/ecs/nodeexporter-service",
          awslogs-region        = "eu-west-1",
          awslogs-stream-prefix = "nodeexporter-service"
        }
      }
    }
  ])
}


resource "aws_ecs_task_definition" "opensearch_task_definition" {
  family             = "opensearch-family"
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  network_mode       = "bridge"
  cpu                = 1536
  memory             = 8192
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = "opensearch-container"
      image     = "opensearchproject/opensearch:latest"
      cpu       = 1536
      memory    = 8192
      essential = true

      portMappings = [
        {
          name          = "opensearch-tcp",
          containerPort = 5601
          hostPort      = 5601
          protocol      = "tcp",
          appProtocol   = "http"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-create-group  = "true",
          awslogs-group         = "/ecs/opensearch-service",
          awslogs-region        = "eu-west-1",
          awslogs-stream-prefix = "opensearch-service"
        }
      }
    }
  ])
}