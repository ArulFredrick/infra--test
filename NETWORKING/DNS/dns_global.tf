terraform {
    required_providers {
      oci = {
        source = "hashicorp/oci"
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

resource "random_string" "random_prefix" {
  length  = 4
  number  = false
  special = false
}

resource "oci_dns_zone" "zone1" {
  compartment_id = var.compartment_ocid
  name           = "${data.oci_identity_tenancy.tenancy.name}-${random_string.random_prefix.result}-dmone	.oci-dns1"
  zone_type      = "PRIMARY"
}

data "oci_dns_zones" "zs" {
  compartment_id = var.compartment_ocid
  name_contains  = "example"
  state          = "ACTIVE"
  zone_type      = "PRIMARY"
  sort_by        = "name" # name|zoneType|timeCreated
  sort_order     = "DESC" # ASC|DESC
}

data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_ocid
}

output "zones" {
  value = data.oci_dns_zones.zs.zones
}

resource "oci_dns_record" "record-a" {
  zone_name_or_id = oci_dns_zone.zone1.name
  domain          = oci_dns_zone.zone1.name
  rtype           = "A"
  rdata           = "192.168.0.1"
  ttl             = 3600
}

data "oci_dns_records" "rs" {
  zone_name_or_id = oci_dns_zone.zone1.name
  # optional
  compartment_id = var.compartment_ocid
  domain         = oci_dns_zone.zone1.name
  sort_by        = "rtype" # domain|rtype|ttl
  sort_order     = "DESC"  # ASC|DESC
}

output "records" {
  value = data.oci_dns_records.rs.records
}
