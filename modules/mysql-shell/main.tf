locals {
  install_script       = "~/install_mysql_shell.sh"
}

data "template_file" "install_mysql_shell" {
  template = file("${path.module}/scripts/install_mysql_shell.sh")
  vars = {
    mysql_version         = var.mysql_version,
    user                  = var.vm_user
  }
}


resource "oci_core_instance" "mysql-shell" {
  compartment_id      = var.compartment_ocid
  display_name        = "${var.label_prefix}${var.display_name}"
  shape               = var.shape
  availability_domain = var.availability_domain

  dynamic "shape_config" {
    for_each = local.is_flexible_node_shape ? [1] : []
    content {
      memory_in_gbs = var.flex_shape_memory
      ocpus = var.flex_shape_ocpus
    }
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    display_name     = "${var.label_prefix}${var.display_name}"
    assign_public_ip = var.assign_public_ip
    hostname_label   = "${var.display_name}"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
  }

  source_details {
    source_id   = var.image_id
    source_type = "image"
  }

  provisioner "file" {
    content     = data.template_file.install_mysql_shell.rendered
    destination = local.install_script

    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key
    }
  }



  provisioner "remote-exec" {
    connection  {
      type        = "ssh"
      host        = self.public_ip
      agent       = false
      timeout     = "5m"
      user        = var.vm_user
      private_key = var.ssh_private_key

  }

    inline = [
       "chmod +x ${local.install_script}",
       "sudo ${local.install_script}"
    ]

   }

  timeouts {
    create = "10m"
  }
}

terraform {
  required_providers {
    oci = {
      source  = "hashicorp/oci"
    }
  }
}
