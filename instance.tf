# Creating RDS instances
 resource "aws_db_instance" "my-db" {
    count = 2
   allocated_storage    = 10
   db_name              = "mydb${count.index+1}"
   engine               = "mysql"
   engine_version       = "5.7"
   instance_class       = "db.t2.micro"
   username             = "admin12345"
   password             = "admin12345"
   parameter_group_name = "default.mysql5.7"
   skip_final_snapshot  = true
   db_subnet_group_name = aws_db_subnet_group.my_db_subnet-group.name
   vpc_security_group_ids = [aws_security_group.db_tier_sg.id]

 }

 
#  #Creating a Key Pair
 
#  #Configuring ec2 instances
#  resource "aws_instance" "app-servers" {
#     count = 2
#     #How do i not hardcode ami's like this
#   ami           = ami-0b5eea76982371e91
#   instance_type = "t2.micro"
#   security_groups = [aws_security_group.app_tier_sg.id]
#   key_name = 
  

#   tags = {
#     Name = "App-Server ${count.index+1}"
#   }
# }

#Creating an aws autoscaling group
resource "aws_launch_template" "ec2-launch-template" {
  name_prefix   = "web-server"
  image_id      = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
}
resource "aws_autoscaling_group" "auto-scale" {
 
  capacity_rebalance  = true
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.priv_sub[0].id, aws_subnet.priv_sub[1].id]
  launch_template {
    id = aws_launch_template.ec2-launch-template.id
  }
  tag {
    key = "server"
    value = "web-server"
    propagate_at_launch = true
    #Here i was trying to create webservers with different names but i cannot use count.propagate_at_launch
    #How can i name servers differently here
    #value = "Web-Server ${count.index+1}"
  }
}
    