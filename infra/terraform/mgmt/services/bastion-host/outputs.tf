output "io2-bastion-ip" {
  value = "${aws_instance.io2-bastion.public_ip}"
}

output "access_key_id" {
  value = "${module.iam.access_key_id}"
}

output "secret_access_key" {
  value = "${module.iam.secret_access_key}"
}
