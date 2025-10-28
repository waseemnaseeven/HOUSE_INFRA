/**
  Provisions an AWS VPC using your CIDR (e.g. 10.15.0.0/16), with DNS resolution and hostnames enabled so EC2 instances can use AWS-provided DNS.
*/
resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  # tags = merge({
  #   Name = coalesce(var.tags["Name"], "vpc-${replace(var.cidr_block, "/.*", "")}")
  # }, var.tags)
}

/**
  Enabling direct Internet access for any subnet whose route table points to it.
*/
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  # tags   = merge({ Name = "${aws_vpc.this.tags["Name"]}-igw" }, var.tags)
}

/**
  Fetches the list of AZs in your region.
  Usage: We’ll use azs.names[count.index] to spread subnets across different AZs.
*/
data "aws_availability_zones" "azs" {}

/**
  Provisions public subnets in differents regions
  Each subnet is placed in a different AZ (count.index selects azs.names[0], azs.names[1], …).
*/
resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch = true # means EC2s in these subnets automatically get a public IPv4.

  # tags = merge({
  #   Name = "${aws_vpc.this.tags["Name"]}-pub-${count.index}"
  # }, var.tags)
}

/**
  Offset slicing: By adding var.public_subnet_count to the count.index, your private subnets occupy the “next” CIDR blocks after the public ones.

  No public IPs: map_public_ip_on_launch = false—instances here cannot be reached directly from the Internet.
*/
resource "aws_subnet" "private" {
  count                   = var.private_subnet_count
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + var.public_subnet_count)
  availability_zone       = data.aws_availability_zones.azs.names[count.index]
  map_public_ip_on_launch = false

  # tags = merge({
  #   Name = "${aws_vpc.this.tags["Name"]}-priv-${count.index}"
  # }, var.tags)
}

/**
 Each NAT Gateway needs its own Elastic IP so that private-subnet traffic appears to come from a stable, routable IP address.
*/
# resource "aws_eip" "nat" {
#   count = 1
# }

/**
  Location: Placed in public subnets so they have Internet access via the IGW.

  Purpose: Allow resources in private subnets to initiate outbound Internet connections (e.g. for patching, yum/apt updates) while still keeping them unreachable from outside.
*/
# resource "aws_nat_gateway" "nat" {
#   count         = 1
#   allocation_id = aws_eip.nat[0].id
#   subnet_id     = aws_subnet.public[0].id
# }

/**
  Route: Sends all outbound traffic (0.0.0.0/0) from public subnets to your IGW.

  Association: Binds that route table to each aws_subnet.public so they become “public.”
*/
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  # tags = merge({ Name = "${aws_vpc.this.tags["Name"]}-rt-public" }, var.tags)
}

resource "aws_route_table_association" "pub_assoc" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

/**
  Route: Sends all outbound traffic from private subnets to the NAT Gateway in the same AZ.

  Association: Ensures instances in aws_subnet.private use this NAT-backed route table.
*/
resource "aws_route_table" "private" {
  count  = var.private_subnet_count
  vpc_id = aws_vpc.this.id

  # route {
  #   cidr_block     = "0.0.0.0/0"
  #   nat_gateway_id = aws_nat_gateway.nat[0].id
  # }

  # tags = merge({
  #   Name = "${aws_vpc.this.tags["Name"]}-rt-priv-${0}"
  # }, var.tags)
}


resource "aws_route_table_association" "priv_assoc" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
