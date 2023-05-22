terraform {
    required_providers {
      oci = {
        source = "hashicorp/oci"
      }
    }
  }
provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}

resource "oci_core_subnet" "public_subnet" {
  cidr_block        = "10.20.30.0/26"
  display_name      = "pub-sn"
  dns_label         = "pubSubnet"
  compartment_id    = var.compartment_ocid
  vcn_id            = var.vcn_ocid
}

resource "oci_core_subnet" "pvt_subnet" {
  cidr_block        = "10.20.30.64/26"
  display_name      = "pvt-sn"
  dns_label         = "pvtSubnet"
  compartment_id    = compartment_ocid
  vcn_id            = var.vcn_ocid
}