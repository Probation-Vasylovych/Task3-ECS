resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "igw-${var.env}"
  })
}

resource "aws_subnet" "this" {
  for_each = var.subnets

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.public

  tags = merge(var.common_tags, {
    Name = "${each.key}-${var.env}"
    Type = each.value.type
  })
}

resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "public-rt-${var.env}"
  })
}

resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "nat-eip-${var.env}"
  })

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id

  subnet_id = aws_subnet.this[
    keys(local.public_subnets)[0]
  ].id

  tags = merge(var.common_tags, {
    Name = "nat-gw-${var.env}"
  })

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "private-rt-${var.env}"
  })
}

resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

resource "aws_route_table_association" "private" {
  for_each = local.private_subnets

  subnet_id      = aws_subnet.this[each.key].id
  route_table_id = aws_route_table.private_rt.id
}