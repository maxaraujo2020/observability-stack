#data "aws_iam_policy_document" "user-service_policy" {
#  statement {
#    sid    = ""
#    effect = "Allow"
##    todo add needed permissions
#    resources = [
#      "arn:aws:s3:::*",
#    ]
#    actions = [
#      "s3:*"
#    ]
#  }
#}
#

# Configure IAM role
resource "aws_iam_role" "observability_role" {
  name = "${var.environment}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "user-service-policy"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "ECSTaskManagement",
          "Effect" : "Allow",
          "Action" : [
            "ec2:AttachNetworkInterface",
            "ec2:CreateNetworkInterface",
            "ec2:CreateNetworkInterfacePermission",
            "ec2:DeleteNetworkInterface",
            "ec2:DeleteNetworkInterfacePermission",
            "ec2:Describe*",
            "ec2:DetachNetworkInterface",
            "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
            "elasticloadbalancing:DeregisterTargets",
            "elasticloadbalancing:Describe*",
            "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
            "elasticloadbalancing:RegisterTargets",
            "route53:ChangeResourceRecordSets",
            "route53:CreateHealthCheck",
            "route53:DeleteHealthCheck",
            "route53:Get*",
            "route53:List*",
            "route53:UpdateHealthCheck",
            "servicediscovery:DeregisterInstance",
            "servicediscovery:Get*",
            "servicediscovery:List*",
            "servicediscovery:RegisterInstance",
            "servicediscovery:UpdateInstanceCustomHealthStatus"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "AutoScaling",
          "Effect" : "Allow",
          "Action" : [
            "autoscaling:Describe*"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "AutoScalingManagement",
          "Effect" : "Allow",
          "Action" : [
            "autoscaling:DeletePolicy",
            "autoscaling:PutScalingPolicy",
            "autoscaling:SetInstanceProtection",
            "autoscaling:UpdateAutoScalingGroup"
          ],
          "Resource" : "*",
          "Condition" : {
            "Null" : {
              "autoscaling:ResourceTag/AmazonECSManaged" : "false"
            }
          }
        },
        {
          "Sid" : "AutoScalingPlanManagement",
          "Effect" : "Allow",
          "Action" : [
            "autoscaling-plans:CreateScalingPlan",
            "autoscaling-plans:DeleteScalingPlan",
            "autoscaling-plans:DescribeScalingPlans"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "CWAlarmManagement",
          "Effect" : "Allow",
          "Action" : [
            "cloudwatch:DeleteAlarms",
            "cloudwatch:DescribeAlarms",
            "cloudwatch:PutMetricAlarm"
          ],
          "Resource" : "arn:aws:cloudwatch:*:*:alarm:*"
        },
        {
          "Sid" : "ECSTagging",
          "Effect" : "Allow",
          "Action" : [
            "ec2:CreateTags"
          ],
          "Resource" : "arn:aws:ec2:*:*:network-interface/*"
        },
        {
          "Sid" : "CWLogGroupManagement",
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:DescribeLogGroups",
            "logs:PutRetentionPolicy"
          ],
          "Resource" : "arn:aws:logs:*:*:log-group:/aws/ecs/*"
        },
        {
          "Sid" : "CWLogStreamManagement",
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogStream",
            "logs:DescribeLogStreams",
            "logs:PutLogEvents"
          ],
          "Resource" : "arn:aws:logs:*:*:log-group:/aws/ecs/*:log-stream:*"
        },
        {
          "Sid" : "ExecuteCommandSessionManagement",
          "Effect" : "Allow",
          "Action" : [
            "ssm:DescribeSessions"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "ExecuteCommand",
          "Effect" : "Allow",
          "Action" : [
            "ssm:StartSession"
          ],
          "Resource" : [
            "arn:aws:ecs:*:*:task/*",
            "arn:aws:ssm:*:*:document/AmazonECS-ExecuteInteractiveCommand"
          ]
        },
        {
          "Sid" : "CloudMapResourceCreation",
          "Effect" : "Allow",
          "Action" : [
            "servicediscovery:CreateHttpNamespace",
            "servicediscovery:CreateService"
          ],
          "Resource" : "*",
          "Condition" : {
            "ForAllValues:StringEquals" : {
              "aws:TagKeys" : [
                "AmazonECSManaged"
              ]
            }
          }
        },
        {
          "Sid" : "CloudMapResourceTagging",
          "Effect" : "Allow",
          "Action" : "servicediscovery:TagResource",
          "Resource" : "*",
          "Condition" : {
            "StringLike" : {
              "aws:RequestTag/AmazonECSManaged" : "*"
            }
          }
        },
        {
          "Sid" : "CloudMapResourceDeletion",
          "Effect" : "Allow",
          "Action" : [
            "servicediscovery:DeleteService"
          ],
          "Resource" : "*",
          "Condition" : {
            "Null" : {
              "aws:ResourceTag/AmazonECSManaged" : "false"
            }
          }
        },
        {
          "Sid" : "CloudMapResourceDiscovery",
          "Effect" : "Allow",
          "Action" : [
            "servicediscovery:DiscoverInstances"
          ],
          "Resource" : "*"
        }
      ]
    })
  }
}

## IAM INSTANCE PROFILE
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.environment}-ecs-instance-profile"
  role = aws_iam_role.observability_role.name
}

data "aws_iam_policy_document" "ecs_instance_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }

  #  statement {
  #    effect = "Allow"
  #    actions = [
  #      "ssmmessages:CreateControlChannel",
  #      "ssmmessages:CreateDataChannel",
  #      "ssmmessages:OpenControlChannel",
  #      "ssmmessages:OpenDataChannel"
  #    ]
  #    resources = ["*"]
  #  }
}

resource "aws_iam_role" "ecs_instance_role" {
  name                = "${var.environment}-ecs-instance-role"
  assume_role_policy  = data.aws_iam_policy_document.ecs_instance_assume_role.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"]
}
