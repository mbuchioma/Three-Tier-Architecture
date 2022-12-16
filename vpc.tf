#Configuring VPC
resource "aws_vpc" "main_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main_vpc"
  }
}

# Configuring Internet gateway and attaching it to the VPC
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "my_igw"
  }
}

#Configuring eip
resource "aws_eip" "my_eip" {
    count =2
  vpc      = true
}

#Configure NAT gateway
resource "aws_nat_gateway" "my_nat" {
    count = 2
  allocation_id = aws_eip.my_eip.*.id[count.index]
  subnet_id     = aws_subnet.pub_sub.*.id[count.index]

  tags = {
    Name = "my_NAT_gw ${count.index+1}"
  }
}

