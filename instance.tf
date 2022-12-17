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
 }