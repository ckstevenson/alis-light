variable "config_file_sh" {
  default = ""
  type    = string
}

source "qemu" "arch" {
  communicator     = "ssh"
  iso_url          = "https://ftp.fau.de/archlinux/iso/2021.07.01/archlinux-2021.07.01-x86_64.iso"
  iso_checksum     = "5804cefb2e5e7498cb15f38180cb3ebc094f6955"
  output_directory = "output-qemu"
  disk_size        = "15G"
  format           = "qcow2"
  http_directory   = "."
  accelerator      = "kvm"
  firmware         = "/usr/share/edk2-ovmf/x64/OVMF.fd"
  ssh_username     = "root"
  ssh_password     = "vagrant"
  ssh_timeout      = "40m"
  vm_name          = "alis.qcow2"
  net_device       = "virtio-net"
  disk_interface   = "virtio"
  headless         = false
  boot_wait        = "5s"
  cpus             = 2
  memory           = 2048
  boot_command = [
    "<wait3s><up><up><up><up><up><enter><wait30s>",
    "/usr/bin/echo -e \"vagrant\\nvagrant\" | /usr/bin/passwd && loadkeys us<enter><wait1s>",
    "curl -O http://{{.HTTPIP}}:{{.HTTPPort}}/packer/download-packer.sh<enter><wait1s>",
    "chmod +x ./*.sh<enter><wait1s>",
    "./download-packer.sh \"{{.HTTPIP}}\" \"{{.HTTPPort}}\" ${var.config_file_sh}<enter><wait1s>",
    "./alis-packer-conf.sh<enter><wait1s>"
  ]
}

build {
  sources = ["source.qemu.arch"]
    provisioner "shell" {
      scripts = [
        #"alis-packer-conf.sh",
        "alis.sh"
      ]
    }
    # Example.
    #    provisioner "ansible" {
    #        playbook_file = "./packer/ansible/arch_provisioner.yml"
    #        user = "root"
    #        extra_arguments = [
    #            "-b",
    #            "--extra-vars",
    #            "ansible_become_password=vagrant",
    #        ]
    #    }
}
