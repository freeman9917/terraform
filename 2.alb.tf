resource "aws_lb" "application_load_balancer" {
    name = "${var.env_prefix}-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.myapp-sg.id]
    subnets = [aws_subnet.my-tr-vpc-public1.id, aws_subnet.my-tr-vpc-public2.id]
    enable_deletion_protection = false
    tags = {
        Name = "${var.env_prefix}-alb"
    }
}

resource "aws_lb_target_group" "alb_target_group" {
    name = "${var.env_prefix}-tg"
    target_type = "instance"
    port = 3000
    protocol = "HTTP"
    vpc_id = aws_vpc.my-tr-vpc.id

    health_check {
        enabled = true
        interval = 15
        path = "/login"
        timeout = 10
        matcher = 200
        healthy_threshold = 5
        unhealthy_threshold = 5
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_lb_listener" "alb_http_listener" {
    load_balancer_arn = aws_lb.application_load_balancer.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.alb_target_group.arn
    }
}
