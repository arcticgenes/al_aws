# TeraData Code Challenge

This repo contains a collection of Terraform files that satisfies the requirements of the code challenge.

3 Web Servers (1 Apache, 2 NGINX) will be in us-west-2 behind a vpc elastic load balancer with SSL termination.

*Note the SSL certificate is created via a terraform resource and is self-signed .  A browser warning will pop-up when accessing the https site*

### Prerequisites
Install terraform on a mac or windows pc

1. In the root directory create a file called terraform.tfvars

Your file will contain 2 lines:

```
access_key = "<input your aws access key>"
secret_key = "<input your aws secret key>"
```

2. Generate an ssh key label it aws_tdcc.pub.  Store public key in the keys folder.


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

*Note - It may take a few minutes for the DNS name of the ELB to propagate out.  The URL endpoints may not work immediately.*

## Authors

* **Aaron Lewis** - *arcticgenes@gmail.com*