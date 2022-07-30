variable "object_bucket" {
    description = "(required) Name of bucket object"
    type        = string
}

variable "object_content" {
    description = "(Optional) The object to upload to the object store. Cannot be defined if source or source_uri_details is defined."
    type        = string
}

variable "object_namespace" {
  description = "(required) Namespace of bucket"
  type =  string
}

variable "region" {
    type = string
    description = "Region for object"
}
