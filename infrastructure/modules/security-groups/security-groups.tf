resource "aws_security_group" "alb" {
  name        = "${var.project}-${var.env}-alb-sg"
  description = "Security group for public ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic from ALB"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-alb-sg"
  })
}

resource "aws_security_group" "web_service" {
  name        = "${var.project}-${var.env}-web-service-sg"
  description = "Security group for ECS web service"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow traffic from ALB to web service"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description     = "Allow Prometheus to scrape web service"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.prometheus_service.id]
  }

  egress {
    description = "Allow all outbound traffic from web service"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-web-service-sg"
  })
}

resource "aws_security_group" "ollama_service" {
  name        = "${var.project}-${var.env}-ollama-service-sg"
  description = "Security group for ECS Ollama service"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow traffic from web service to Ollama"
    from_port       = 11434
    to_port         = 11434
    protocol        = "tcp"
    security_groups = [aws_security_group.web_service.id]
  }

  ingress {
    description     = "Allow Prometheus to scrape Ollama"
    from_port       = 11434
    to_port         = 11434
    protocol        = "tcp"
    security_groups = [aws_security_group.prometheus_service.id]
  }

  egress {
    description = "Allow all outbound traffic from Ollama service"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-ollama-service-sg"
  })
}

resource "aws_security_group" "grafana_service" {
  name        = "${var.project}-${var.env}-grafana-service-sg"
  description = "Security group for ECS Grafana service"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow traffic from ALB to Grafana"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow all outbound traffic from Grafana service"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-grafana-service-sg"
  })
}

resource "aws_security_group" "prometheus_service" {
  name        = "${var.project}-${var.env}-prometheus-service-sg"
  description = "Security group for ECS Prometheus service"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow Grafana to query Prometheus"
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = [aws_security_group.grafana_service.id]
  }

  ingress {
    description     = "Allow Grafana to query Prometheus"
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }


  egress {
    description = "Allow all outbound traffic from Prometheus service"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-prometheus-service-sg"
  })
}

resource "aws_security_group" "rds" {
  name        = "${var.project}-${var.env}-rds-sg"
  description = "Security group for PostgreSQL RDS"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow PostgreSQL from web service"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web_service.id]
  }

  egress {
    description = "Allow all outbound traffic from RDS"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-rds-sg"
  })
}

resource "aws_security_group_rule" "web_to_prometheus_9090" {
  type                     = "ingress"
  description              = "Allow web service (Alloy sidecar) to send metrics to Prometheus"
  from_port                = 9090
  to_port                  = 9090
  protocol                 = "tcp"
  security_group_id        = aws_security_group.prometheus_service.id
  source_security_group_id = aws_security_group.web_service.id
}

resource "aws_security_group_rule" "ollama_to_prometheus_9090" {
  type                     = "ingress"
  description              = "Allow Ollama service (Alloy sidecar) to send metrics to Prometheus"
  from_port                = 9090
  to_port                  = 9090
  protocol                 = "tcp"
  security_group_id        = aws_security_group.prometheus_service.id
  source_security_group_id = aws_security_group.ollama_service.id
}