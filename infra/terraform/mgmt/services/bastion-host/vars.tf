variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

variable "ssh_port" {
  description = "The port for SSH connection"
  default     = 22
}

variable "region" {
  description = "Desired aws region"
  default     = "us-west-2"
}

variable "ssh_key_location" {
  default = "/home/lsetiawan/.ssh/id_rsa.pub"
}
