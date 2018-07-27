output "io2-bastion-ip" {
  value = "${aws_instance.io2-bastion.public_ip}"
}
