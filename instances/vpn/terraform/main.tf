terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      version = ">= 4.0.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

resource "oci_core_instance" "vpn" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  display_name        = var.instance_display_name
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_cpu
    memory_in_gbs = var.instance_memory
  }

  create_vnic_details {
    subnet_id                 = oci_core_subnet.default.id
    display_name              = "Default"
    assign_public_ip          = true
    assign_private_dns_record = true
    hostname_label            = "vpn"
  }

  source_details {
    source_type = "image"
    source_id   = var.instance_image_ocid
  }

  metadata = {
    ssh_authorized_keys = file(var.instance_ssh_public_key)
  }

  timeouts {
    create = "60m"
  }
}

output "instance_public_ip" {
  value = oci_core_instance.vpn.public_ip
}
