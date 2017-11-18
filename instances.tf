resource "aws_instance" "tdcc-nginx" {
  count = 2
  ami           = "${var.ami}"
  instance_type = "${var.instance}"
  key_name = "${aws_key_pair.tdcc-keypair.key_name}"
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.tdcc-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.tdcc-instances.id}"]
  user_data = "${data.template_file.nginx_userdata.rendered}"
  tags {
    Name = "AaronCC-nginx${count.index}"
  }
}

resource "aws_instance" "tdcc-apache" {
  ami           = "${var.ami}"
  instance_type = "${var.instance}"
  key_name = "${aws_key_pair.tdcc-keypair.key_name}"
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.tdcc-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.tdcc-instances.id}"]
  user_data = "${data.template_file.apache_userdata.rendered}"
  tags {
    Name = "AaronCC-apache"
  }
}

output "nginx_addresses" {
  value = ["${aws_instance.tdcc-nginx.*.public_ip}"]
}

output "apache_address" {
  value = ["${aws_instance.tdcc-apache.*.public_ip}"]
}