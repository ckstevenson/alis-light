#!/usr/bin/env bash
set -e

# Arch Linux Install Script (alis) installs unattended, automated
# and customized Arch Linux system.
# Copyright (C) 2021 picodotdev

#CONFIG_FILE="alis-packer.json"
CONFIG_FILE="alis-packer.pkr.hcl"

# Grub Working
#CONFIG_FILE_SH="alis-packer-efi-ext4-luks-grub.sh"
#CONFIG_FILE_SH="alis-packer-efi-ext4-luks-lvm-grub.sh"
#CONFIG_FILE_SH="alis-packer-efi-btrfs-luks-lvm-grub.sh"
CONFIG_FILE_SH="alis-packer-efi-btrfs-luks-grub.sh"

# Systemd not booting
#CONFIG_FILE_SH="alis-packer-efi-ext4-luks-systemd.sh" # Not Working
#CONFIG_FILE_SH="alis-packer-efi-btrfs-luks-systemd.sh" # Not Working
#CONFIG_FILE_SH="alis-packer-efi-btrfs-luks-lvm-systemd.sh" # Not Working

# Refind not working
#CONFIG_FILE_SH="alis-packer-efi-btrfs-luks-refind.sh"

while getopts "c:" arg; do
  case $arg in
    c)
      CONFIG_FILE_SH="$OPTARG"
      ;;
  esac
done

packer validate "packer/$CONFIG_FILE"
packer build -force -on-error=ask -var "config_file_sh=$CONFIG_FILE_SH" "packer/$CONFIG_FILE"
