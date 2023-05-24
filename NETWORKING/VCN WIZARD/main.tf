terraform {
  backend "http" {
    update_method = "PUT"
  }
}
provider "oci" {
  region           = var.region
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
}



#VCN

resource "oci_core_vcn" "vcn1" {
  cidr_block     = "10.20.30.0/24"
  dns_label      = "dmonedns"
  compartment_id = var.compartment_ocid
  display_name   = "dmone-vcn"
}
resource "oci_core_internet_gateway" "test_internet_gateway" {
  compartment_id =  var.compartment_ocid
  display_name   = "dmone-igw"
  vcn_id         = oci_core_vcn.vcn1.id
}

resource "oci_core_nat_gateway" "test_nat_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn1.id
  display_name   = "dmone-nat"
}

data "oci_core_services" "test_services" {
  filter {
    name   = "name"
    values = ["All HYD Services In Oracle Services Network"]
    regex  = true
  }
}

resource "oci_core_service_gateway" "test_service_gateway" {
  #Required
  compartment_id = var.compartment_ocid

  services {
    service_id = data.oci_core_services.test_services.services[0]["id"]
  }

  vcn_id = oci_core_vcn.vcn1.id

  #Optional
  display_name   = "dmone-sgw"
  # route_table_id = oci_core_route_table.route_table1.id
}

resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.vcn1.default_route_table_id
  display_name               = "default-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.test_internet_gateway.id
  }
}

resource "oci_core_route_table" "route_table1" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn1.id
  display_name   = "pvt-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.test_nat_gateway.id
  }

   route_rules {
    destination       = data.oci_core_services.test_services.services[0]["cidr_block"]
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.test_service_gateway.id
  }
}

resource "oci_core_default_dhcp_options" "default_dhcp_options" {
  manage_default_resource_id = oci_core_vcn.vcn1.default_dhcp_options_id
  display_name               = "defaultDhcpOptions"

  // required
  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }
  // optional
    # options {
    #   type                = "SearchDomain"
    #   search_domain_names = ["testvcn.oraclevcn.com"]
    # }
}

resource "oci_core_default_security_list" "default_security_list" {
  manage_default_resource_id = oci_core_vcn.vcn1.default_security_list_id
  display_name               = "default-sl"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  // allow outbound udp traffic on a port range
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "17" // udp
    stateless   = true

    udp_options {
      min = 319
      max = 320
    }
  }

  // allow inbound ssh traffic
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
  }
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 80
      max = 80
    }
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    protocol  = 1
    source    = "0.0.0.0/0"
    stateless = true

    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    protocol  = 1
    source    = "12.0.0.0/16"
    stateless = true

    icmp_options {
      type = 3
    }
  }
}

resource "oci_core_security_list" "pvt_security_list" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn1.id
  display_name   = "pvt-sl"

  // allow outbound tcp traffic on all ports
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  // allow inbound ssh traffic from a specific port
  ingress_security_rules {
    protocol  = "6" // tcp
    source    = "12.0.0.0/16"
    stateless = false

    tcp_options {
      source_port_range {
        min = 100
        max = 100
      }

      // These values correspond to the destination port range.
      min = 22
      max = 22
    }
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    description = "allow inbound icmp traffic for mentioned port"
    protocol    = 1
    source      = "0.0.0.0/0"
    stateless   = true

    icmp_options {
      type = 3
      code = 4
    }
  }

  // allow inbound icmp traffic of a specific type
  ingress_security_rules {
    description = "ICMP traffic for: 3 Destination Unreachable"
    protocol    = 1
    source      = "12.0.0.0/16"
    stateless   = true

    icmp_options {
      type = 3
    }
  }
}


#SUBNETS

resource "oci_core_subnet" "public_subnet" {
  cidr_block        = "10.20.30.0/26"
  display_name      = "pub-sn"
  dns_label         = "pubSubnet"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.vcn1.id
  security_list_ids = [oci_core_vcn.vcn1.default_security_list_id]
  route_table_id    = oci_core_vcn.vcn1.default_route_table_id
  dhcp_options_id   = oci_core_vcn.vcn1.default_dhcp_options_id
}

resource "oci_core_subnet" "pvt_subnet" {
  cidr_block        = "10.20.30.64/26"
  display_name      = "pvt-sn"
  dns_label         = "pvtSubnet"
  compartment_id    =var.compartment_ocid
  vcn_id            = oci_core_vcn.vcn1.id
  security_list_ids = [oci_core_security_list.pvt_security_list.id]
  route_table_id    = oci_core_route_table.route_table1.id
  dhcp_options_id   = oci_core_default_dhcp_options.default_dhcp_options.id
}