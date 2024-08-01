
# Grafana
resource "aws_ecr_repository" "grafana_repository" {
  name = "${var.project}-${var.environment}-grafana-ecr"

  tags = {
    Name        = "${var.project}-${var.environment}-grafana-ecr"
    Team        = "acloud"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

resource "aws_ecr_lifecycle_policy" "grafana_repository_lifecycle" {
  repository = aws_ecr_repository.grafana_repository.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 10 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}

# Prometheus
resource "aws_ecr_repository" "prometheus_repository" {
  name = "${var.project}-${var.environment}-prometheus-ecr"

  tags = {
    Name        = "${var.project}-${var.environment}-prometheus-ecr"
    Team        = "acloud"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

resource "aws_ecr_lifecycle_policy" "prometheus_repository_lifecycle" {
  repository = aws_ecr_repository.prometheus_repository.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 10 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}


# Node Exporter
# resource "aws_ecr_repository" "nodeexporter_repository" {
#   name = "${var.project}-${var.environment}-nodeexporter-ecr"

#   tags = {
#     Name        = "${var.project}-${var.environment}-nodeexporter-ecr"
#     Team        = "acloud"
#     Project     = "${var.project}"
#     Environment = "${var.environment}"
#     Region      = "${var.region}"
#   }
# }

# resource "aws_ecr_lifecycle_policy" "nodeexporter_repository_lifecycle" {
#   repository = aws_ecr_repository.nodeexporter_repository.name

#   policy = jsonencode({
#     rules = [{
#       rulePriority = 1
#       description  = "Keep last 10 images"
#       action = {
#         type = "expire"
#       }
#       selection = {
#         tagStatus   = "any"
#         countType   = "imageCountMoreThan"
#         countNumber = 10
#       }
#     }]
#   })
# }
