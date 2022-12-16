# Configure public route table
resource "aws_route_table" "pub_rt" {  
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "pub_route_table"
  }
}

# resource "aws_route_table_association" "pub_rt_association" {
#   subnet_id      = aws_subnet.pub_sub.id[index]
#   route_table_id = aws_route_table.pub_route_table.id
# }