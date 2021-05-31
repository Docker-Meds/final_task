provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "Web" {
  ami                    = "ami-077e31c4939f6a2f3"
  instance_type          = "t2.micro"
  iam_instance_profile   = "ec2s3"
  key_name               = "apache2"
  vpc_security_group_ids = ["sg-079ee76d456b97e62"]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
sudo service httpd start
chkonfig httpd on
sudo chgrp -R ec2-user /var/www
sudo chmod -R a+rw /var/www
mkdir /home/ec2-user/s3
sudo amazon-linux-extras install epel
sudo yum -y install s3fs-fuse
sudo s3fs mycontentapache2 /home/ec2-user/s3/ -o iam_role=ec2s3
sudo cp -avr /home/ec2-user/s3/img /var/www/html/
sudo chmod 777 /var/www/html/img/

EOF
tags = {
 Name = "Apache2_AMI"
}

}

output "public_ip" {
 value = aws_instance.Web.public_ip
}


