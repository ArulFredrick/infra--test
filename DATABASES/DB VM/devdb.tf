terraform {
    required_providers {
      oci = {
        source = "oracle/oci"
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

# Get DB node list
data "oci_database_db_nodes" "db_nodes" {
  compartment_id = var.compartment_ocid
  db_system_id   = oci_database_db_system.test_db_system.id
}

# Get DB node details
data "oci_database_db_node" "db_node_details" {
  db_node_id = data.oci_database_db_nodes.db_nodes.db_nodes[0]["id"]
}

data "oci_database_db_homes" "db_homes" {
  compartment_id = var.compartment_ocid
  db_system_id   = oci_database_db_system.test_db_system.id
}

data "oci_database_databases" "databases" {
  compartment_id = var.compartment_ocid
  db_home_id     = data.oci_database_db_homes.db_homes.db_homes[0].db_home_id
}

data "oci_database_db_versions" "test_db_versions_by_db_system_id" {
  compartment_id = var.compartment_ocid
  db_system_id   = oci_database_db_system.test_db_system.id
}

data "oci_database_db_system_shapes" "test_db_system_shapes" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid

  filter {
    name   = "shape"
    values = [var.db_system_shape]
  }
}

data "oci_database_db_systems" "db_systems" {
  compartment_id = var.compartment_ocid

  filter {
    name   = "id"
    values = [oci_database_db_system.test_db_system.id]
  }
}

resource "oci_database_db_system" "test_db_system" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_ocid
  database_edition    = var.db_edition

  db_home {
    database {
      admin_password = var.db_admin_password
      db_name        = "dmdb"
      character_set  = var.character_set
      ncharacter_set = var.n_character_set
      db_workload    = var.db_workload
      pdb_name       = var.pdb_name

      db_backup_config {
        auto_backup_enabled = false
      }
    }

    db_version   = var.db_version
    display_name = "dmonedb"
  }

  db_system_options {
    storage_management = "ASM"
  }

  disk_redundancy         = var.db_disk_redundancy
  shape                   = var.db_system_shape
  cpu_core_count          ="1"
  subnet_id               = var.subnet_id
  ssh_public_keys         = [var.ssh_public_key]
  display_name            = "dmonedb"
  hostname                = var.hostname
  data_storage_size_in_gb = var.data_storage_size_in_gb
  license_model           = var.license_model
  node_count              = data.oci_database_db_system_shapes.test_db_system_shapes.db_system_shapes[0]["minimum_node_count"]
}