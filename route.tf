# Configure public route table
resource "aws_route_table" "pub_rt" {  
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "pub_route_table"
  }
}


resource "aws_route_table_association" "pub_sub_rt_association" {
    count = length(aws_subnet.pub_sub)
    #Got the * online I do not know what it means
  subnet_id      = aws_subnet.pub_sub.*.id[count.index]
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route" "pub_default_route" {
  route_table_id            = aws_route_table.pub_rt.id
  gateway_id = aws_internet_gateway.my_igw.id
  destination_cidr_block    = "0.0.0.0/0"
  
}

# Configure Private Routes

resource "aws_route_table" "priv_rt" {  
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "priv_route_table"
  }
}

resource "aws_route_table_association" "priv_sub_rt_association" {
    count = length(aws_subnet.priv_sub)
    #Got the * online I do not know what it means
  subnet_id      = aws_subnet.priv_sub.*.id[count.index]
  route_table_id = aws_route_table.priv_rt.id
}

resource "aws_route" "default_priv_route" {
    count = length(aws_nat_gateway.my_nat)
  route_table_id            = aws_route_table.priv_rt.id
  #Why Should be destination everywhere for 
  nat_gateway_id = aws_nat_gateway.my_nat.*.id[count.index]
  destination_cidr_block    = "0.0.0.0/0"

}




