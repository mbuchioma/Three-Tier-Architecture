# Configuring Private subnets
resource "aws_subnet" "priv_sub" {
    count = 4
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.priv_cidr[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "priv_sub ${count.index+1}"
  }
}

# Configuring Public subnets
resource "aws_subnet" "pub_sub" {
    count = 2
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.pub_cidr[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "pub_sub ${count.index+1}"
  }
}