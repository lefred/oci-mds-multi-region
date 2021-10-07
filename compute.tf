// Compute Instance in the Source Region
module "mysql-shell-source" {
  source                = "./modules/mysql-shell"
  availability_domain  = data.template_file.ad_names_source.*.rendered[0]
  compartment_ocid      = var.compartment_ocid
  image_id              = var.node_image_id == "" ? data.oci_core_images.images_for_shape_source.images[0].id : var.node_image_id
  shape                 = var.node_shape
  label_prefix          = var.label_prefix
  subnet_id             = local.public_subnet_id_source
  ssh_authorized_keys   = local.ssh_key
  ssh_private_key       = local.ssh_private_key
  display_name          = "MySQLShellSource" 
  flex_shape_ocpus      = var.node_flex_shape_ocpus
  flex_shape_memory     = var.node_flex_shape_memory
}

module "mysql-shell-replica" {
  providers = {
    oci = oci.replica
  }
  source                = "./modules/mysql-shell"
  availability_domain   = data.template_file.ad_names_replica.*.rendered[0]
  compartment_ocid      = var.compartment_ocid
  image_id              = var.node_image_id == "" ? data.oci_core_images.images_for_shape_replica.images[0].id : var.node_image_id
  shape                 = var.node_shape
  label_prefix          = var.label_prefix
  subnet_id             = local.public_subnet_id_replica
  ssh_authorized_keys   = local.ssh_key
  ssh_private_key       = local.ssh_private_key
  display_name          = "MySQLShellReplica" 
  flex_shape_ocpus      = var.node_flex_shape_ocpus
  flex_shape_memory     = var.node_flex_shape_memory
}
