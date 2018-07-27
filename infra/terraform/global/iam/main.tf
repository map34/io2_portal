resource "aws_iam_group" "kops-group" {
  name = "io2-kops"
}

# Then parse through the list using count
resource "aws_iam_group_policy_attachment" "kops-group-attach" {
  group      = "${aws_iam_group.kops-group.name}"
  count      = "${length(var.iam_policy_arn)}"
  policy_arn = "${var.iam_policy_arn[count.index]}"
}

resource "aws_iam_user" "kops-user" {
  name = "kops-manager"
}

resource "aws_iam_group_membership" "kops-group-member" {
  name = "kops-group-membership"

  users = [
    "${aws_iam_user.kops-user.name}",
  ]

  group = "${aws_iam_group.kops-group.name}"
}

resource "aws_iam_access_key" "kops-user" {
  user = "${aws_iam_user.kops-user.name}"
}
