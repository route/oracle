variable "tenancy_ocid" {
  type = string
}

variable "compartment_ocid" {
  type = string
}

variable "user_ocid" {
  type = string
}

variable "fingerprint" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "region" {
  type = string
}

variable "instance_display_name" {
  type = string
}

variable "instance_shape" {
  type = string
}

variable "instance_cpu" {
  type = number
}

variable "instance_memory" {
  type = number
}

variable "instance_image_ocid" {
  type = string
}

variable "instance_ssh_public_key" {
  type = string
}

variable "oci_core_subnet_id" {
  type = string
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}
