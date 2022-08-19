provider "aws" {
    region = var.AWS_REGION
    access_key = var.AWS_ACCESS_KEY
    secret_key = var.AWS_SECRET_KEY
}

resource "aws_security_group" "instance_sg" {
    name = "terraform-test-sg"

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "my_ec2_instance" {
    ami = var.AWS_AMIS[var.AWS_REGION]
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.instance_sg.id]

	user_data = <<-EOF
		#!/bin/bash
        sudo apt-get update
		sudo apt-get install -y apache2
		sudo systemctl start apache2
		sudo systemctl enable apache2
		echo "<h1>Hello devopssec</h1>" > /var/www/html/index.html
	EOF
    
    tags = {
        Name = "terraform test"
    }
}

output "public_ip" {
  value       = aws_instance.my_ec2_instance.public_ip
}
