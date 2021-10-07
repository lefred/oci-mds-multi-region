// DRG Source

resource "oci_core_drg" "mds_drg_source" {
  provider       = oci.source
  display_name   = "MDS_DRG_Source"
  compartment_id = var.compartment_ocid
}

resource "oci_core_drg_attachment" "mds_drg_attachment_source" {
  provider   = oci.source
  drg_id     = oci_core_drg.mds_drg_source.id
  vcn_id     = local.vcn_id_source
}

resource "oci_core_remote_peering_connection" "mds_rpc_source" {
  provider          = oci.source
  compartment_id    = var.compartment_ocid
  drg_id            = oci_core_drg.mds_drg_source.id
  display_name      = "MDS_RPC_Source"
  peer_id           = oci_core_remote_peering_connection.mds_rpc_replica.id
  peer_region_name  = var.region_replica
}

// DRG Replica

resource "oci_core_drg" "mds_drg_replica" {
  provider       = oci.replica
  display_name   = "MDS_DRG_Replica"
  compartment_id = var.compartment_ocid
}

resource "oci_core_drg_attachment" "mds_drg_attachment_replica" {
  provider   = oci.replica
  drg_id     = oci_core_drg.mds_drg_replica.id
  vcn_id     = local.vcn_id_replica
}

resource "oci_core_remote_peering_connection" "mds_rpc_replica" {
  provider          = oci.replica
  compartment_id    = var.compartment_ocid
  drg_id            = oci_core_drg.mds_drg_replica.id
  display_name      = "MDS_RPC_Replica"
}
