# --- modules/networking/main.tf ---

## Define what AZ will be used in the Subnets
resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

## Create the infrastructure - VPC
resource "aws_vpc" "vpc_network" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project}-${var.environment}-vpc"
    Team        = "acloud"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

## Creating Public Subnets
resource "aws_subnet" "public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.vpc_network.id
  cidr_block              = var.public_cidrs[count.index]
  availability_zone       = random_shuffle.az_list.result[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project}-public-${var.environment}-sbn"
    Team        = "acloud"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

## Creating Private Subnets
resource "aws_subnet" "private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.vpc_network.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name        = "${var.project}-private-${var.environment}-sbn"
    Team        = "acloud"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

## Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_network.id

  tags = {
    Name        = "${var.project}-${var.environment}-igw"
    Team        = "acloud"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

## Creating NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.private_sn_count
  allocation_id = aws_eip.elastic_ip.*.id[count.index]
  subnet_id     = aws_subnet.public_subnet.*.id[count.index]
  depends_on    = [aws_internet_gateway.internet_gateway]

  tags = {
    Name        = "${var.project}-${var.environment}-ngw"
    Team        = "acloud"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

## Grant the VPC internet access on its main route table - Public Route
resource "aws_route" "public_route" {
  route_table_id         = aws_vpc.vpc_network.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc_network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name        = "${var.project}-public-${var.environment}-rt"
    Team        = "acloud"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

resource "aws_route_table_association" "route_table_public_association" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.public_subnet["${count.index}"].id
  route_table_id = aws_route_table.route_table_public.id
}

## Grant the VPC internet access on its main route table - Private Route
resource "aws_route" "private_route" {
  count                  = var.private_sn_count
  route_table_id         = aws_route_table.route_table_private.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.*.id[count.index]
}

resource "aws_route_table" "route_table_private" {
  count  = var.private_sn_count
  vpc_id = aws_vpc.vpc_network.id

  tags = {
    Name        = "${var.project}-private-${var.environment}-rt"
    Team        = "acloud"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

resource "aws_route_table_association" "route_table_private_association" {
  count          = var.private_sn_count
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
  route_table_id = aws_route_table.route_table_private.*.id[count.index]
}

## Ensures all Public Subnets have elastic ips
resource "aws_eip" "elastic_ip" {
  count  = var.public_sn_count
  domain = "vpc"

  tags = {
    Name        = "${var.project}-${var.environment}-eip"
    Team        = "acloud"
    Project     = "${var.project}"
    Environment = "${var.environment}"
    Region      = "${var.region}"
  }
}

## Security Groups used to the observability
resource "aws_security_group" "autoscaling_sg" {
  name        = "${var.project}-observability-sg"
  vpc_id      = aws_vpc.vpc_network.id
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
    description = "Security Group used to Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Security Group used to OpenSearch"
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Security Group used to Alertmanager"
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "Security Group used to Kibana"
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