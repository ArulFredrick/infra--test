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

data "oci_objectstorage_namespace" "ns" {
  #Optional
  compartment_id = var.compartment_ocid
}

output "namespace" {
  value = data.oci_objectstorage_namespace.ns.namespace
}

resource "oci_objectstorage_bucket" "bucket1" {
  compartment_id = var.compartment_ocid
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = "dmone-bkt"
  access_type    = "NoPublicAccess"
  auto_tiering = "Disabled"
}

data "oci_objectstorage_bucket_summaries" "buckets1" {
  compartment_id = var.compartment_ocid
  namespace = data.oci_objectstorage_namespace.ns.namespace
  filter {
    name   = "name"
    values = [oci_objectstorage_bucket.bucket1.name]
  }
}

output "buckets" {
  value = data.oci_objectstorage_bucket_summaries.buckets1.bucket_summaries
}
