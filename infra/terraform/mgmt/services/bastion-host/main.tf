module "iam" {
  source = "../../../global/iam"
}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${module.iam.cred}"
}

resource "aws_instance" "io2-bastion" {
  ami                    = "ami-ba602bc2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.io2-bastion-sc.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  key_name = "${aws_key_pair.don-laptop.key_name}"

  tags {
    Name    = "io2-bastion-test"
    Owner   = "Don"
    Project = "IO2 Portal"
  }
}

resource "aws_security_group" "io2-bastion-sc" {
  name = "io2-bastion-sc"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "${var.ssh_port}"
    to_port     = "${var.ssh_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "don-laptop" {
  key_name   = "don-laptop"
  public_key = "${file("${var.ssh_key_location}")}"
}
