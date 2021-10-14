#!/bin/bash

echo adding a new region...

# get the amount of replica(s)

replica_nb=$(grep "vcn_id_replica.* = " main.tf | wc -l)
replica_nb=$((replica_nb + 1))
route_nb=$((replica_nb + 1))
new="$(sed 's/2/'$route_nb'/g' tools/extra/locals)"
new=$(echo "$new" | sed 's/replica/replica'$replica_nb'/g')
tmpfile=$(mktemp)
echo "$new" > $tmpfile
sed -i "/# NEW REGION/r $tmpfile" main.tf

new="$(sed 's/replica/replica'$replica_nb'/g' tools/extra/shape)"
echo "$new" > $tmpfile
sed -i "/# NEW REPLICA IMAGE/r $tmpfile" main.tf

new="$(sed 's/NBREPLICA/'$replica_nb'/g' tools/extra/routerules)"
echo "$new" > $tmpfile
sed -i "/# NEW REPLICA ROUTE RULES/r $tmpfile" main.tf

new="$(sed 's/replica/replica'$replica_nb'/g' tools/extra/securityrules)"
echo "$new" > $tmpfile
sed -i "/# NEW INGRESS SECURITY RULES/r $tmpfile" main.tf

new="$(sed 's/replica/replica'$replica_nb'/g' tools/extra/variables)"
echo >> variables.tf
echo "$new" >> variables.tf 

cp replica.tf replica${replica_nb}.tf
sed -i "s/2/$route_nb/g" replica${replica_nb}.tf
sed -i "s/replica/replica$replica_nb/g" replica${replica_nb}.tf
sed -i "s/Replica/Replica$replica_nb/g" replica${replica_nb}.tf

cp tools/extra/drg drg${replica_nb}.tf
sed -i "s/NBREPLICA/$replica_nb/g" drg${replica_nb}.tf

cp inbound.tf inbound${replica_nb}.tf
sed -i "s/replica/replica$replica_nb/g" inbound${replica_nb}.tf

cat << EOF >> output.tf

output "mds_instance_ip_replica${replica_nb}" {
  value = module.mds-instance_replica${replica_nb}.private_ip
}
EOF

cat << EOF2 >> provider.tf

provider "oci" {
  region = var.region_replica${replica_nb}
  user_ocid = var.user_ocid
  fingerprint = var.fingerprint
  private_key_path = var.private_key_path
  tenancy_ocid = var.tenancy_ocid
  alias = "replica${replica_nb}"
}
EOF2

cat << EOF3 >> terraform.tfvars

region_replica${replica_nb} = "ap-tokyo-1" 
vcn_cidr_replica${replica_nb} = "10.${replica_nb}.0.0/16" 
EOF3


