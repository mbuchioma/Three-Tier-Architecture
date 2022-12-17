resource "aws_security_group" "web_tier_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main_vpc.id



  ingress {
    
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web-tier-sg"
  }
}

# Configure Application Load balancer SG
resource "aws_security_group" "app_lb_sg" {
  name        = "app-lb-sg"
  description = "Allows inbound http traffic from the internet/everywhere"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "Allow http traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }



  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "app-lb-sg"
  }
}
 

#Configure Application Tier SG
resource "aws_security_group" "app_tier_sg" {
  name        = "app-tier-sg"
  description = "Allows http from inbound load balancer"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "Allow http traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.app_lb_sg.id]
  }



  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "app-tier-sg"
  }
}

#Configure Application Tier SG
resource "aws_security_group" "db_tier_sg" {
  name        = "db-tier-sg"
  description = "Allows http from inbound app-tier"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "Allow http traffic from application tier"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.app_tier_sg.id]
  }



  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "db-tier-sg"
  }
}