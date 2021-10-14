
locals {
  vcn_id_source = var.existing_vcn_ocid_source == "" ? oci_core_virtual_network.mysqlvcn1[0].id : var.existing_vcn_ocid_source
  internet_gateway_id_source = var.existing_internet_gateway_ocid_source == "" ? oci_core_internet_gateway.internet_gateway1[0].id : var.existing_internet_gateway_ocid_source
  nat_gateway_id_source = var.existing_nat_gateway_ocid_source == "" ? oci_core_nat_gateway.nat_gateway1[0].id : var.existing_nat_gateway_ocid_source
  public_route_table_id_source = var.existing_public_route_table_ocid_source == "" ? oci_core_route_table.public_route_table1[0].id : var.existing_public_route_table_ocid_source
  private_route_table_id_source = var.existing_private_route_table_ocid_source == "" ? oci_core_route_table.private_route_table1[0].id : var.existing_private_route_table_ocid_source
  private_subnet_id_source = var.existing_private_subnet_ocid_source == "" ? oci_core_subnet.private1[0].id : var.existing_private_subnet_ocid_source
  public_subnet_id_source = var.existing_public_subnet_ocid_source == "" ? oci_core_subnet.public1[0].id : var.existing_public_subnet_ocid_source
  private_security_list_id_source = var.existing_private_security_list_ocid_source == "" ? oci_core_security_list.private_security_list1[0].id : var.existing_private_security_list_ocid_source
  public_security_list_id_source = var.existing_public_security_list_ocid_source == "" ? oci_core_security_list.public_security_list1[0].id : var.existing_public_security_list_ocid_source

  vcn_id_replica = var.existing_vcn_ocid_replica == "" ? oci_core_virtual_network.mysqlvcn2[0].id : var.existing_vcn_ocid_replica
  internet_gateway_id_replica = var.existing_internet_gateway_ocid_replica == "" ? oci_core_internet_gateway.internet_gateway2[0].id : var.existing_internet_gateway_ocid_replica
  nat_gateway_id_replica = var.existing_nat_gateway_ocid_replica == "" ? oci_core_nat_gateway.nat_gateway2[0].id : var.existing_nat_gateway_ocid_replica
  public_route_table_id_replica = var.existing_public_route_table_ocid_replica == "" ? oci_core_route_table.public_route_table2[0].id : var.existing_public_route_table_ocid_replica
  private_route_table_id_replica = var.existing_private_route_table_ocid_replica == "" ? oci_core_route_table.private_route_table2[0].id : var.existing_private_route_table_ocid_replica
  private_subnet_id_replica = var.existing_private_subnet_ocid_replica == "" ? oci_core_subnet.private2[0].id : var.existing_private_subnet_ocid_replica
  public_subnet_id_replica = var.existing_public_subnet_ocid_replica == "" ? oci_core_subnet.public2[0].id : var.existing_public_subnet_ocid_replica
  private_security_list_id_replica = var.existing_private_security_list_ocid_replica == "" ? oci_core_security_list.private_security_list2[0].id : var.existing_private_security_list_ocid_replica
  public_security_list_id_replica = var.existing_public_security_list_ocid_replica == "" ? oci_core_security_list.public_security_list2[0].id : var.existing_public_security_list_ocid_replica

  # NEW REGION

  ssh_key = var.ssh_authorized_keys_path == "" ? tls_private_key.public_private_key_pair.public_key_openssh : file(var.ssh_authorized_keys_path)
  ssh_private_key = var.ssh_private_key_path == "" ? tls_private_key.public_private_key_pair.private_key_pem : file(var.ssh_private_key_path)
  private_key_to_show = var.ssh_private_key_path == "" ? local.ssh_private_key : var.ssh_private_key_path

}

data "oci_identity_availability_domains" "ad_source" {
  compartment_id = var.tenancy_ocid
  provider = oci.source
}

data "template_file" "ad_names_source" {
  count    = length(data.oci_identity_availability_domains.ad_source.availability_domains)
  template = lookup(data.oci_identity_availability_domains.ad_source.availability_domains[count.index], "name")
}

data "oci_core_images" "images_for_shape_source" {
    compartment_id = var.compartment_ocid
    operating_system = "Oracle Linux"
    operating_system_version = "8"
    shape = var.node_shape
    sort_by = "TIMECREATED"
    sort_order = "DESC"
}

data "oci_core_images" "images_for_shape_replica" {
    compartment_id = var.compartment_ocid
    operating_system = "Oracle Linux"
    operating_system_version = "8"
    shape = var.node_shape
    sort_by = "TIMECREATED"
    sort_order = "DESC"
    provider = oci.replica
}    
    
# NEW REPLICA IMAGE

data "oci_mysql_mysql_configurations" "shape" {
    compartment_id = var.compartment_ocid
    type = ["DEFAULT"]
    shape_name = var.mysql_shape
}

resource "tls_private_key" "public_private_key_pair" {
  algorithm = "RSA"
}

// Source

resource "oci_core_virtual_network" "mysqlvcn1" {
  cidr_block = var.vcn_cidr_source
  compartment_id = var.compartment_ocid
  display_name = var.vcn_source
  dns_label = "mysqlvcn1"
  provider = oci.source

  count = var.existing_vcn_ocid_source == "" ? 1 : 0
}


resource "oci_core_internet_gateway" "internet_gateway1" {
  compartment_id = var.compartment_ocid
  display_name = "internet_gateway_1"
  vcn_id = local.vcn_id_source
  provider = oci.source

  count = var.existing_internet_gateway_ocid_source == "" ? 1 : 0
}


resource "oci_core_nat_gateway" "nat_gateway1" {
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id_source
  display_name   = "nat_gateway1"
  provider = oci.source

  count = var.existing_nat_gateway_ocid_source == "" ? 1 : 0
}


resource "oci_core_route_table" "public_route_table1" {
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id_source
  display_name = "RouteTableForMySQLPublic1"
  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = local.internet_gateway_id_source
  }

  route_rules {
        destination       = var.vcn_cidr_replica
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_drg.mds_drg_source.id
  }

  # NEW REPLICA ROUTE RULES

  provider = oci.source

  count = var.existing_public_route_table_ocid_source == "" ? 1 : 0
}

resource "oci_core_security_list" "public_security_list1" {
  compartment_id = var.compartment_ocid
  display_name = "Allow Public SSH Connections to Eventual Servers in Public Subnet"
  vcn_id = local.vcn_id_source
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "6"
  }
  ingress_security_rules {
    tcp_options {
      max = 22
      min = 22
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }

  count = var.existing_public_security_list_ocid_source == "" ? 1 : 0
}



resource "oci_core_route_table" "private_route_table1" {
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id_source
  display_name   = "RouteTableForMySQLPrivate1"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = local.nat_gateway_id_source
  }
  route_rules {
        destination       = var.vcn_cidr_replica
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_drg.mds_drg_source.id
  }

  # NEW REPLICA ROUTE RULES

  count = var.existing_private_route_table_ocid_source == "" ? 1 : 0
  provider = oci.source
}

resource "oci_core_security_list" "private_security_list1" {
  compartment_id = var.compartment_ocid
  display_name   = "Private1"
  vcn_id = local.vcn_id_source

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
  ingress_security_rules  {
    protocol = "1"
    source   = var.vcn_cidr_source
  }
  ingress_security_rules  {
    tcp_options  {
      max = 22
      min = 22
    }
    protocol = "6"
    source   = var.vcn_cidr_source
  }
  ingress_security_rules  {
    tcp_options  {
      max = 3306
      min = 3306
    }
    protocol = "6"
    source   = var.vcn_cidr_source
  }
  ingress_security_rules  {
    tcp_options  {
      max = 33061
      min = 33060
    }
    protocol = "6"
    source   = var.vcn_cidr_source
  }
  ingress_security_rules  {
    tcp_options  {
      max = 3306
      min = 3306
    }
    protocol = "6"
    source   = var.vcn_cidr_replica
  }
  ingress_security_rules  {
    tcp_options  {
      max = 33061
      min = 33060
    }
    protocol = "6"
    source   = var.vcn_cidr_replica
  }
  # NEW INGRESS SECURITY RULES 
  provider = oci.source

  count = var.existing_private_security_list_ocid_source == "" ? 1 : 0
}

resource "oci_core_subnet" "public1" {
  cidr_block = cidrsubnet(var.vcn_cidr_source, 8, 0)
  display_name = "mysql_public_subnet1"
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id_source
  route_table_id = local.public_route_table_id_source
  security_list_ids = [local.public_security_list_id_source]
  dns_label = "mysqlpub1"
  provider = oci.source

  count = var.existing_public_subnet_ocid_source == "" ? 1 : 0
}

resource "oci_core_subnet" "private1" {
  cidr_block                 = cidrsubnet(var.vcn_cidr_source, 8, 1)
  display_name               = "mysql_private_subnet1"
  compartment_id             = var.compartment_ocid
  vcn_id                     = local.vcn_id_source
  route_table_id             = local.private_route_table_id_source
  security_list_ids          = [local.private_security_list_id_source]
  prohibit_public_ip_on_vnic = "true"
  dns_label                  = "mysqlpriv1"
  provider = oci.source

  count = var.existing_private_subnet_ocid_source == "" ? 1 : 0

}

module "mds-instance" {
  source         = "./modules/mds-instance"
  admin_password = var.admin_password
  admin_username = var.admin_username
  availability_domain = data.template_file.ad_names_source.*.rendered[0]
  configuration_id = data.oci_mysql_mysql_configurations.shape.configurations[0].id
  compartment_ocid = var.compartment_ocid
  subnet_id = local.private_subnet_id_source
  display_name = "${var.mds_instance_name}_Source"
  existing_mds_instance_id  = var.existing_mds_instance_ocid_source
  mysql_shape = var.mysql_shape
  deploy_ha = var.deploy_mds_ha
}

