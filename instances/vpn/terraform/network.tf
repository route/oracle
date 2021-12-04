resource "oci_core_vcn" "default" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_ocid
  display_name   = "Default"
  dns_label      = "default"
}

resource "oci_core_internet_gateway" "default" {
  compartment_id = var.compartment_ocid
  display_name   = "DefaultGateway"
  vcn_id         = oci_core_vcn.default.id
}

resource "oci_core_default_route_table" "default" {
  manage_default_resource_id = oci_core_vcn.default.default_route_table_id
  display_name               = "DefaultRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.default.id
  }
}

resource "oci_core_subnet" "default" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "10.0.0.0/24"
  display_name        = "DefaultSubnet"
  dns_label           = "default"
  security_list_ids   = [oci_core_vcn.default.default_security_list_id, oci_core_security_list.default.id]
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.default.id
  route_table_id      = oci_core_vcn.default.default_route_table_id
  dhcp_options_id     = oci_core_vcn.default.default_dhcp_options_id
}


resource "oci_core_security_list" "default" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.default.id
  display_name   = "DefaultSecurityList"

  ingress_security_rules {
    protocol = "17" // udp
    source   = "0.0.0.0/0"

    udp_options {
      max = 1194
      min = 1194
    }
  }

  ingress_security_rules {
    protocol = "47" // gre
    source   = "0.0.0.0/0"
  }
}
