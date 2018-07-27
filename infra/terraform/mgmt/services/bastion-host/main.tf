module "iam" {
  source = "../../../global/iam"
}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${module.iam.cred}"
}

data "template_file" "io2-setup" {
  template = "${file("${var.setup_script}")}"

  vars {
    aws_key_id     = "${module.iam.access_key_id}"
    aws_secret     = "${module.iam.secret_access_key}"
    region_default = "${var.region}"
    kops_s3_store  = "${aws_s3_bucket.kops-bucket.id}"
    user_home      = "/home/ubuntu"
    cluster_name   = "io2kops.k8s.local"
    zones          = "us-west-2a,us-west-2b,us-west-2c"
    master_size    = "t2.micro"
    master_volume  = 10
    node_size      = "t2.medium"
    node_volume    = 10
    node_count     = 2
  }
}

resource "aws_instance" "io2-bastion" {
  ami                    = "ami-ba602bc2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.io2-bastion-sc.id}"]

  user_data = "${data.template_file.io2-setup.rendered}"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "don-laptop" {
  key_name   = "don-laptop"
  public_key = "${file("${var.ssh_key_location}")}"
}

resource "aws_s3_bucket" "kops-bucket" {
  bucket = "kops-state-store-ooica"
  acl    = "private"

  tags {
    Name    = "KOPS State Store"
    Owner   = "don"
    Project = "IO2 Portal"
  }

  versioning {
    enabled = true
  }
}
