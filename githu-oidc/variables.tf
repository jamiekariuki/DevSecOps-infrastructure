variable "branch" {
  type = string
  default = "main"
}

variable "repository" {
  type = string
}

variable "s3_policy" {
  type = string
}

variable "ecr_policy" {
  type = string
}

variable "terraform_policy" {
  type = string
}

