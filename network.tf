resource "aws_vpc" "tdcc-vpc" {
  cidr_block = "10.10.0.0/16"
  tags {
    Name = "tdcc-vpc"
  }
}

resource "aws_subnet" "tdcc-subnet" {
  vpc_id     = "${aws_vpc.tdcc-vpc.id}"
  cidr_block = "10.10.0.0/24"
  tags {
    Name = "tdcc-subnet"
  }
}

resource "aws_internet_gateway" "tdcc-gw" {
  vpc_id = "${aws_vpc.tdcc-vpc.id}"
  tags {
    Name = "tdcc-gw"
  }
}

resource "aws_route_table" "tdcc-routetable" {
  vpc_id = "${aws_vpc.tdcc-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.tdcc-gw.id}"
  }

  tags {
    Name = "tdcc-routetable"
  }
}

resource "aws_route_table_association" "tdcc-rta" {
  subnet_id      = "${aws_subnet.tdcc-subnet.id}"
  route_table_id = "${aws_route_table.tdcc-routetable.id}"
}

resource "aws_security_group" "tdcc-web" {
  name        = "tdcc-web"
  description = "Allow web traffic"
  vpc_id      = "${aws_vpc.tdcc-vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = "${var.webserverport}"
    to_port         = "${var.webserverport}"
    protocol        = "tcp"
    cidr_blocks     = ["${aws_subnet.tdcc-subnet.cidr_block}"]
  }
}

resource "aws_security_group" "tdcc-instances" {
  name        = "tdcc-instances"
  description = "Allow ssh and elb traffic"
  vpc_id      = "${aws_vpc.tdcc-vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.tdssh}","${var.homessh}"]
  }

  ingress {
    from_port   = "${var.webserverport}"
    to_port     = "${var.webserverport}"
    protocol    = "tcp"
    security_groups= ["${aws_security_group.tdcc-web.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "tdcc-web-elb" {
  name = "tdcc-web-elb"
  security_groups = ["${aws_security_group.tdcc-web.id}"]
  subnets = ["${aws_subnet.tdcc-subnet.id}"]
  listener {
    instance_port     = "${var.webserverport}"
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  listener {
    instance_port     = "${var.webserverport}"
    instance_protocol = "http"
    lb_port           = 443
    lb_protocol       = "https"
    ssl_certificate_id = "${aws_iam_server_certificate.tdcc-sslcert.arn}"
  }
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    timeout             = 5
    target              = "HTTP:${var.webserverport}/index.html"
    interval            = 30
  }
  instances = ["${aws_instance.tdcc-nginx.*.id}","${aws_instance.tdcc-apache.id}"]
  idle_timeout                = 300
  connection_draining         = true
  connection_draining_timeout = 300
}

output "tdcc-public-dns" {
  value = ["${aws_elb.tdcc-web-elb.dns_name}"]
}