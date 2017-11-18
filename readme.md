# TeraData Code Challenge

This repo contains a collection of Terraform files that satisfies the requirements of the code challenge.

(3) ubuntu web servers (1 Apache, 2 NGINX) will be created in a aws region behind a vpc elastic load balancer with SSL termination.


### Prerequisites
Install terraform on a mac or windows pc

1. In the root directory create a file called terraform.tfvars

Your file will contain 2 lines:

```
access_key = "<input your aws access key>"
secret_key = "<input your aws secret key>"
```

2. Generate an ssh key and label it aws_tdcc.pub.  Store the public key in the keys folder of the repo.


### Deploying
To run the automation you navigate to the repo run 3 commands

```
terraform init
```
This will grab all the providers needed to run the automation


```
terraform plan
```
This will display all the actions that the automation is about to perform


```
terraform apply
```
This will kick off the automation.  When finished it will output the public IPs of the (3) webservers and the public DNS entry of the ELB.

## Disclaimers

*The SSL certificate is created via a terraform resource and is self-signed. A browser warning will pop-up when accessing the https site*

*DNS propogations from AWS can take a few minutes.  The URL endpoints may not work immediately.*

## Authors

* **Aaron Lewis** - *arcticgenes@gmail.com*