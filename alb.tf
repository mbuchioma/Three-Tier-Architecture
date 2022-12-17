resource "aws_lb" "test" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_lb_sg.id]
  #subnets            = [for subnet in aws_subnet.priv_sub : subnet.id]
  #I am not sure if this makes sense association subnets to the LB this way
  subnets            = [aws_subnet.priv_sub[0].id, aws_subnet.priv_sub[1].id,]

  enable_deletion_protection = false

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.bucket
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    Environment = "production"
  }
}