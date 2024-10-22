provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_key_pair" "example" {
  key_name   = "example-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "example" {
  name_prefix = "example-sg"
  vpc_id      = "vpc-049c7ce9e354b1684"  # Use your VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami               = "ami-060e277c0d4cce553"    # valid AMI for ubuntu
  instance_type     = "t2.micro"
  key_name          = aws_key_pair.example.key_name
  subnet_id         = "subnet-0eff5dfa5368470f9"    # Use your subnet ID
  vpc_security_group_ids = [aws_security_group.example.id]
  associate_public_ip_address = true 


provisioner "remote-exec" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  inline = [
    "sudo apt update -y",
    "sudo apt install -y nginx",
    "sudo systemctl enable nginx",
    "sudo systemctl start nginx"
  ]
}

  provisioner "local-exec" {
    command = "echo Instance ${self.public_ip} created! > instance_ip.txt"
  }

  provisioner "remote-exec" {
    when    = "destroy"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }

    inline = [
      "sudo systemctl stop nginx",
      "sudo apt remove -y nginx"
    ]
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "echo Instance ${self.public_ip} destroyed! > instance_ip.txt"
  }
}

