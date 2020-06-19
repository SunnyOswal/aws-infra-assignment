data "aws_availability_zones" "az" {
}
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr_block}"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "public" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

resource "aws_subnet" "default" {
  count                   = 2
  cidr_block              = "${element(var.public_subnet_cidr_blocks, count.index)}"
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone       = "${data.aws_availability_zones.az.names[count.index]}"
  map_public_ip_on_launch = true
}