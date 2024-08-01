# --- container/main.tf ---
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project}-${var.environment}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = "ecs_observability-logs"
      }
    }
  }

  tags = {
    Name        = "${var.project}-${var.environment}-ecs-cluster"
    Team        = "acloud"
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.project}-${var.environment}-ecsTaskRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF

  tags = {
    Name        = "${var.project}-${var.environment}-ecsTaskRole"
    Team        = "acloud"
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project}-${var.environment}-policy-ecs"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF

  tags = {
    Name        = "${var.project}-${var.environment}-policy-ecs"
    Team        = "acloud"
    Project     = var.project
    Environment = var.environment
    Region      = var.region
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_secretmanger" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_cloudwatch" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = "${var.environment}-ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "${var.environment}-ecs-agent"
  role = aws_iam_role.ecs_agent.name
}