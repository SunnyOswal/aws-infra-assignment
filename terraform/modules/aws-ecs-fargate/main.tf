resource "aws_security_group" "ecs-lb-sg" {
  name        = "${var.service_name}-ecs-sg"
  description = "Allow inbound access from the ALB only"
  vpc_id      = "${var.vpc_id}"

  ingress {
    protocol        = "tcp"
    from_port       = 1
    to_port         = 65535
    security_groups = ["${var.load_balancer_security_group_id}"]    
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_iam_policy_document" "default" {
  version = "2012-10-17"
  statement {
    sid = ""
    effect = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  name               = "${var.service_name}-ecs-task-role"
  assume_role_policy = "${data.aws_iam_policy_document.default.json}"
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = "${aws_iam_role.default.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_cluster" "default" {
  name = "${var.service_name}-cluster"
}
resource "aws_ecs_task_definition" "default" {
  family                   = "${var.service_name}-td"
  execution_role_arn       = "${aws_iam_role.default.arn}"
  container_definitions    = "${var.task_definition_file}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
}

resource "aws_ecs_service" "default" {
  name            = "${var.service_name}-ecs"
  cluster         = "${aws_ecs_cluster.default.id}"
  task_definition = "${aws_ecs_task_definition.default.arn}"
  desired_count   = 2
  launch_type = "FARGATE"

   network_configuration {
    security_groups  = ["${var.load_balancer_security_group_id}"]
    subnets          = "${var.subnets}"
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${var.load_balancer_target_group_arn}"
    container_name   = "${var.service_name}"
    container_port   = "${var.container_port}"
  }
  depends_on = [var.ecs_depends_on]
}

