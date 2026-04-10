resource "aws_service_discovery_private_dns_namespace" "this" {
  name = var.namespace_name
  vpc  = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${var.project}-${var.env}-sd-namespace"
  })
}