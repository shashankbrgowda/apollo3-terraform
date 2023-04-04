variable "keypair" {
  type    = string
  default = "mongo"
}

variable "network" {
  type    = string
  default = "ensembl-infra-public"
}

variable "security_groups" {
  type    = list(string)
  default = ["default", "mongo", "http", "infra-public-default"]
}

variable "image" {
	type    = string
	default = "8319ed9b-f5b1-46e3-9b2a-f859777eacce"
}

variable "flavor" {
	type    = string
	default = "8b530555-0bf1-4d89-b1dc-e05b65acea3a"
}

variable "availability_zone" {
	type    = string
	default = "nova"
}