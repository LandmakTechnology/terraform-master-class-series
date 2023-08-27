#1. VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    "Tier" = "Staging"
  }
}

resource "aws_flow_log" "main_vpc" {
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
  iam_role_arn    = aws_iam_role.example.arn
  log_destination = aws_cloudwatch_log_group.example.arn
}


#2. Internet gateway
resource "aws_internet_gateway" "my_gw" {
  count = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = local.vpc_id
}

#3. Public Subnets
resource "aws_subnet" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  vpc_id     = local.vpc_id
  cidr_block = element(concat(var.public_subnets, [""]), count.index)
  #cidr_block = cidrsubnet(var.vpc_cidr,8 ,count.index )

  tags = {
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/demo" = "owned"
  }
}

data "aws_availability_zones" "my_zones" {
  state = "available"
}

#4. Private subnets
resource "aws_subnet" "private" {
  #for_each = toset(data.aws_availability_zones.my_zones.names)
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id = local.vpc_id
  #cidr_block = "var.private_subnets"
  cidr_block = element(concat(var.private_subnets, [""]), count.index)
  #availability_zone = each.value #data.aws_availability_zones.available.names[*]
  #cidr_block = cidrsubnet(var.vpc_cidr,8 ,count.index )

  tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/demo"      = "owned"
  }
}

#5. Public route table
resource "aws_route_table" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = local.vpc_id

  depends_on = [aws_subnet.public]
}

#6. Private route table
resource "aws_route_table" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? 1 : 0

  vpc_id = local.vpc_id

  depends_on = [aws_subnet.private]
}

#7. Public routes
resource "aws_route" "public_internet_gateway" {
  count = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_gw[0].id

  depends_on = [aws_route_table.public]
}

#8. Private routes
resource "aws_route" "private_nat_gateway" {
  count = var.create_vpc && var.create_nat_gw && length(var.private_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.private[0].id
  nat_gateway_id         = aws_nat_gateway.my_nat_gw.id
  destination_cidr_block = "0.0.0.0/0"

  depends_on = [aws_route_table.private]
}

#9. Public rt association
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id

  depends_on = [aws_route.public_internet_gateway, aws_subnet.public]
}

#10. Private rt association
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private[0].id

  depends_on = [aws_route.private_nat_gateway, aws_subnet.private]
}

locals {
  vpc_id = aws_vpc.main.id
}

#11. EIP
resource "aws_eip" "my_eip" {
  vpc = true
}

#12. NAT gateway
resource "aws_nat_gateway" "my_nat_gw" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.my_gw]
}
/*
moved {
  from = aws_subnet.public
  to   = aws_subnet.public1
}
*/
