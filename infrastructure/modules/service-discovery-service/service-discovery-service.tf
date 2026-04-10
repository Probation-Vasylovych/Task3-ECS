resource "aws_service_discovery_service" "this" {
  name = var.service_name

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      type = "A"
      ttl  = var.ttl
    }

    routing_policy = "MULTIVALUE"
  }

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-${var.service_name}-discovery-service"
  })
}