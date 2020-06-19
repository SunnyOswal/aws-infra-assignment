resource "aws_lb_target_group" "default" {
  name        = "${var.service_name}-lb-tg"
  port        = "${var.target_group_port}"
  protocol    = "HTTP"
  target_type = "${var.target_type}"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_security_group" "lb-http-ingress-egress" {
  name        = "${var.service_name}-lb-sg"
  description = "ALB Allowed ports"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "${var.http_port}"
    to_port     = "${var.http_port}"
    protocol    = "tcp"
    cidr_blocks = "${var.ingress_cidr_blocks}"
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_lb" "default" {
  name               = "${var.service_name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.lb-http-ingress-egress.id}"]
  subnets            = "${var.subnets}"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.default.arn}"
  port              = "${var.http_port}"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.default.arn}"
  }
}
