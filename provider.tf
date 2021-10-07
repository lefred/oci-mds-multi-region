provider "oci" {
  region = var.region_source
  user_ocid = var.user_ocid
  fingerprint = var.fingerprint
  private_key_path = var.private_key_path
  tenancy_ocid = var.tenancy_ocid
}

provider "oci" {
  region = var.region_source
  user_ocid = var.user_ocid
  fingerprint = var.fingerprint
  private_key_path = var.private_key_path
  tenancy_ocid = var.tenancy_ocid
  alias = "source"
}

provider "oci" {
  region = var.region_replica
  user_ocid = var.user_ocid
  fingerprint = var.fingerprint
  private_key_path = var.private_key_path
  tenancy_ocid = var.tenancy_ocid
  alias = "replica"
}