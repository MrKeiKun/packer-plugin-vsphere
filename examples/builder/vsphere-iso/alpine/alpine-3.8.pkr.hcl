# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are analogous to the "builders" in json templates. They are used
# in build blocks. A build block runs provisioners and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "vsphere-iso" "autogenerated_1" {
  CPUs                 = 1
  RAM                  = 512
  RAM_reserve_all      = true
  boot_command         = ["root<enter><wait>", "mount -t vfat /dev/fd0 /media/floppy<enter><wait>", "setup-alpine -f /media/floppy/answerfile<enter>", "<wait5>", "jetbrains<enter>", "jetbrains<enter>", "<wait5>", "y<enter>", "<wait10><wait10><wait10><wait10>", "reboot<enter>", "<wait10><wait10>", "root<enter>", "jetbrains<enter><wait>", "mount -t vfat /dev/fd0 /media/floppy<enter><wait>", "/media/floppy/SETUP.SH<enter>"]
  boot_wait            = "15s"
  disk_controller_type = ["pvscsi"]
  floppy_files         = ["${path.root}/answerfile", "${path.root}/setup.sh"]
  guest_os_type        = "other3xLinux64Guest"
  host                 = "esxi-01.example.com"
  insecure_connection  = true
  iso_paths            = ["[datastore1] ISO/alpine-standard-3.8.2-x86_64.iso"]
  network_adapters {
    network_card = "vmxnet3"
  }
  password     = "VMw@re1!"
  ssh_password = "VMw@re1!"
  ssh_username = "packer"
  storage {
    disk_size             = 1024
    disk_thin_provisioned = true
  }
  username       = "administrator@vsphere.local"
  vcenter_server = "vcenter.example.com"
  vm_name        = "alpine-${local.timestamp}"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.vsphere-iso.autogenerated_1"]

  provisioner "shell" {
    inline = ["ls /"]
  }
}
