provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_key_pair" "tdcc-keypair" {
  key_name = "${var.keyname}"
  public_key = "${file("./keys/id_aws_tdcc.pub")}"
}

resource "tls_private_key" "tdcc-key" {
  algorithm   = "RSA"
  rsa_bits = "4096"
}

resource "tls_self_signed_cert" "tdcc-sslcert" {
  key_algorithm   = "${tls_private_key.tdcc-key.algorithm}"
  private_key_pem = "${tls_private_key.tdcc-key.private_key_pem}"

  subject {
    common_name  = "codechallenge.td.com"
    organization = "TD"
    organizational_unit = "DevOps"
    country = "US"
  }

  dns_names = ["td.com"]

  validity_period_hours = 240

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_iam_server_certificate" "tdcc-sslcert" {
  name_prefix      = "tdcc-sslcert"
  certificate_body = "${tls_self_signed_cert.tdcc-sslcert.cert_pem}"
  private_key      = "${tls_private_key.tdcc-key.private_key_pem}"
}

data "template_file" "nginx_userdata" {
  template = "${file("./templates/nginx_userdata.tpl")}"

  vars {
    log_path = "${var.logpath}"
    server_port = "${var.webserverport}"
  }
}

data "template_file" "apache_userdata" {
  template = "${file("./templates/apache_userdata.tpl")}"

  vars {
    log_path = "${var.logpath}"
    server_port = "${var.webserverport}"
  }
}