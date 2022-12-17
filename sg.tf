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

#Configure Database Tier SG
resource "aws_security_group" "db_tier_sg" {
  name        = "db-tier-sg"
  description = "Allows mysql inbound traffic from app-tier"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port        = 3306
    to_port          = 3306
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


#Configuring an aws db subnet group
# What is the role of creating a database subnet group
resource "aws_db_subnet_group" "my_db_subnet-group" {
  name       = "db-subnet-group"
  #How can i list in a better way if it has to be multiple DB subnet groups instances
  subnet_ids = [aws_subnet.priv_sub[2].id, aws_subnet.priv_sub[3].id]

  tags = {
    Name = "My DB subnet group"
  }
}

#Configuring an aws application subnet group
# What is the role of creating a database subnet group
#created and realised that subnet group for instances has no command in terraform
# resource "aws_db_subnet_group" "my_app_subnet-group" {
#   name       = "app-subnet-group"
#   #How can i list in a better way if it has to be multiple DB subnet groups instances
#   subnet_ids = [aws_subnet.priv_sub[0].id, aws_subnet.priv_sub[1].id]

#   tags = {
#     Name = "My App subnet group"
#   }
# }