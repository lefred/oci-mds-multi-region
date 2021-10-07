resource "oci_mysql_channel" "replica_channel" {
  provider          = oci.replica
  compartment_id    = var.compartment_ocid
  display_name       = "Replication from ${var.region_source}"  
  is_enabled        = true
  source {
      hostname      =  module.mds-instance.private_ip
      port          = 3306
      username      = var.admin_username
      password      = var.admin_password
      source_type   = "MYSQL"
      ssl_mode      = "DISABLED"
  }
  target {
      db_system_id = module.mds-instance_replica.ocid
      target_type = "DBSYSTEM"
  }

}