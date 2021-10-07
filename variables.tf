variable "tenancy_ocid" {
  description = "Tenancy's OCID"
}

variable "user_ocid" {
  description = "User's OCID"
  default = ""
}

variable "compartment_ocid" {
  description = "Compartment's OCID where VCN will be created. "
}

variable "private_key_path" {
  description = "The private key path to pem. DO NOT FILL WHEN USING RESOURCE MANAGER STACK! "
  default     = ""
}

variable "fingerprint" {
  description = "Key Fingerprint"
  default     = ""
}

variable "dns_label" {
  description = "Allows assignment of DNS hostname when launching an Instance. "
  default     = ""
}

variable "label_prefix" {
  description = "To create unique identifier for multiple setup in a compartment."
  default     = ""
}


variable "admin_password" {
  description = "Password for the admin user for MySQL Database Service"
}

variable "admin_username" {
  description = "MySQL Database Service Username"
  default = "admin"
}

variable "mysql_shape" {
    default = "MySQL.HeatWave.VM.Standard.E3"
}

variable "mds_instance_name" {
  description = "Name of the MDS instance"
  default     = "MySQLInstance"
}

# Source Information

variable "region_source" {
  description = "OCI Region for Replication Source"
}

variable "existing_vcn_ocid_source" {
  description = "OCID of an existing VCN to use for the Source"
  default     = ""
}

variable "existing_public_subnet_ocid_source" {
  description = "OCID of an existing public subnet to use for the Source"
  default     = ""
}

variable "existing_private_subnet_ocid_source" {
  description = "OCID of an existing private subnet to use for the Source"
  default     = ""
}

variable "existing_internet_gateway_ocid_source" {
  description = "OCID of an existing internet gateway to use for the Source"
  default     = ""
}

variable "existing_nat_gateway_ocid_source" {
  description = "OCID of an existing NAT gateway to use for the Source"
  default     = ""
}

variable "existing_public_route_table_ocid_source" {
  description = "OCID of an existing public route table to use for the Source"
  default     = ""
}

variable "existing_private_route_table_ocid_source" {
  description = "OCID of an existing private route table to use for the Source"
  default     = ""
}

variable "existing_public_security_list_ocid_source" {
  description = "OCID of an existing public security list (ssh) to use for the Source"
  default     = ""
}

variable "existing_private_security_list_ocid_source" {
  description = "OCID of an existing private security list allowing MySQL access to use for the Source"
  default     = ""
}

variable "existing_mds_instance_ocid_source" {
  description = "OCID of an existing MDS instance to use for the Source"
  default     = ""
}


variable "vcn_source" {
  description = "VCN Name for the Source"
  default     = "mysql_vcn"
}

variable "vcn_cidr_source" {
  description = "VCN's CIDR IP Block for the Source"
  default     = "10.0.0.0/16"
}

# Replica Information

variable "region_replica" {
  description = "OCI Region for Replication Replica"
}

variable "existing_vcn_ocid_replica" {
  description = "OCID of an existing VCN to use for the Replica"
  default     = ""
}

variable "existing_public_subnet_ocid_replica" {
  description = "OCID of an existing public subnet to use for the Replica"
  default     = ""
}

variable "existing_private_subnet_ocid_replica" {
  description = "OCID of an existing private subnet to use for the Replica"
  default     = ""
}

variable "existing_internet_gateway_ocid_replica" {
  description = "OCID of an existing internet gateway to use for the Replica"
  default     = ""
}

variable "existing_nat_gateway_ocid_replica" {
  description = "OCID of an existing NAT gateway to use for the Replica"
  default     = ""
}

variable "existing_public_route_table_ocid_replica" {
  description = "OCID of an existing public route table to use for the Replica"
  default     = ""
}

variable "existing_private_route_table_ocid_replica" {
  description = "OCID of an existing private route table to use for the Replica"
  default     = ""
}

variable "existing_public_security_list_ocid_replica" {
  description = "OCID of an existing public security list (ssh) to use for the Replica"
  default     = ""
}

variable "existing_private_security_list_ocid_replica" {
  description = "OCID of an existing private security list allowing MySQL access to use for the Replica"
  default     = ""
}

variable "existing_mds_instance_ocid_replica" {
  description = "OCID of an existing MDS instance to use for the Replica"
  default     = ""
}

variable "vcn_replica" {
  description = "VCN Name for the Replica"
  default     = "mysql_vcn_replica"
}

variable "vcn_cidr_replica" {
  description = "VCN's CIDR IP Block for the Replica"
  default     = "10.1.0.0/16"
}

// Compute instance info

variable "ssh_private_key_path" {
  description = "The private key path to access instance. DO NOT FILL WHEN USING RESOURCE MANAGER STACK!"
  default     = ""
}

variable "ssh_authorized_keys_path" {
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance. DO NOT FILL WHEN USING REOSURCE MANAGER STACK!"
  default     = ""
}

variable "node_image_id" {
  description = "The OCID of an image for a node instance to use. "
  default     = ""
}

variable "node_shape" {
  description = "Instance shape to use for master instance. "
  default     = "VM.Standard.E4.Flex"
}

variable "node_flex_shape_ocpus" {
  description = "Flex Instance shape OCPUs"
  default = 1
}

variable "node_flex_shape_memory" {
  description = "Flex Instance shape Memory (GB)"
  default = 8
}

variable "deploy_mds_ha" {
  description = "Deploy High Availability for MDS Source"
  type        = bool
  default     = false
}

