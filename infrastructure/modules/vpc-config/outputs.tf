output "public_subnet_ids" {
  value = [
    for k, v in aws_subnet.this : v.id
    if var.subnets[k].public
  ]
}

output "private_fargate_subnet_ids" {
  value = [
    for k, v in aws_subnet.this : v.id
    if var.subnets[k].type == "private-fargate"
  ]
}

output "private_rds_subnet_ids" {
  value = [
    for k, v in aws_subnet.this : v.id
    if var.subnets[k].type == "private-rds"
  ]
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw.id
}