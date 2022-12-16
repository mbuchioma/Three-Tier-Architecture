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
    Name = "my_ign"
  }
}

