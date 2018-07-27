variable "cred" {
  description = "The location of aws credential file"
  default     = "/home/lsetiawan/.aws/credentials"
}

variable "iam_policy_arn" {
  description = "IAM Policy to be attached to role"
  type        = "list"

  default = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
  ]
}
