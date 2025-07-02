variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "eks_role_arn" {
  type = string
}

variable "node_role_arn" {
  type = string
}

variable "security_group_ids" {
  description = "Security group IDs to associate with the EKS cluster"
  type        = list(string)
  default     = []
}
