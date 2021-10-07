
output "private_ip" {
  value = data.oci_mysql_mysql_db_system.MDSinstance_to_use.ip_address
}

output "ocid" {
  value = data.oci_mysql_mysql_db_system.MDSinstance_to_use.id
}