variable "AWS_SECRET_ACCESS_KEY" {
  default = ""
}

variable "AWS_ACCESS_KEY_ID" {
  default = ""
}

data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" "default"{
  default=true
}

resource "aws_instance" "web_vlg" {
  ami           = data.aws_ami.app_ami.id
  instance_type = var.instance_type
  
  vpc_security_group_ids = [aws_security_group.blog.id]
  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_security_group" "blog"{
  name        = "blog"
  description = "Allow http(s) in. everything out"

  vpc_id      = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "blog_http_in" {
  type= "ingress"
  from_port  = 80
  to_port    = 80
  protocol   = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id=aws_security_group.blog.id
}
resource "aws_security_group_rule" "blog_https_in" {
  type= "ingress"
  from_port  = 443
  to_port    = 443
  protocol   = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id=aws_security_group.blog.id
}
resource "aws_security_group_rule" "blog_everythn_out" {
  type= "egress"
  from_port  = 80
  to_port    = 80
  protocol   = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id=aws_security_group.blog.id
}