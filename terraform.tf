terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

// add AWS provider

provider "aws" {
  region = "eu-central-1"
}

// add EC2 instance

resource "aws_instance" "aws_jenkins" {
  // ubuntu image
  ami           = "ami-0e63910157459607d"
  instance_type = "t2.micro"
  // assign security group to this instance
  vpc_security_group_ids = [aws_security_group.jenkins_group.id]
  // assign bash script to post install on the vm
  user_data = templatefile("install_jenkins.sh.tpl", {})
  // create local file with public ip address
  provisioner "local-exec" {
    command = "echo ${aws_instance.aws_jenkins.public_ip} > ip_address.txt"
  }
  // add name of the instance
  tags = {
		Name = "Aws terraform jenkins"
	}
}

// create aws security group

resource "aws_security_group" "jenkins_group" {
  name = "Jenkins security group"
  description = "Open ports for http, ssh"
  
  // inbound ports
  // open 80
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // open 22
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  //open 8080
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // outbound ports
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "ip" {
  vpc = true
  instance = aws_instance.aws_jenkins.id
}

// output of the assign ip address
output "ip" {
  value = aws_eip.ip.public_ip
}
