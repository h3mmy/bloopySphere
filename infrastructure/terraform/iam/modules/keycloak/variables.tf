variable "realm_name" {
  type = string
}

variable "user_groups" {
  type = list(object({
    name  = string
    parent_group = optional(string)
    attributes = optional(map(list(string)),{})
    realm_roles = optional(list(string),[])
  }))
  default = []
}

variable "smtp_username" {
    type = string
    sensitive = true
}

variable "smtp_password" {
    type = string
    sensitive = true
}

variable "smtp_host" {
  type = string
}

variable "domain" {
  type = string
  sensitive = true
}

variable "realm_roles" {
  type = list(object({
    name  = string
    description = optional(string)
    composite = bool
    client_role = bool
    attributes = optional(map(list(string)),{})
    realm_roles = optional(list(string),[])
  }))
  default = []
}
