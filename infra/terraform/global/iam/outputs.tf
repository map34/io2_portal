output "cred" {
  value = "${var.cred}"
}

output "access_key_id" {
  value = "${aws_iam_access_key.kops-user.id}"
}

output "secret_access_key" {
  value = "${aws_iam_access_key.kops-user.secret}"
}
