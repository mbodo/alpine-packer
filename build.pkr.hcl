variable "accelerator" {
  type    = string
  default = "kvm"
}

variable "disk_size" {
  type    = string
  default = "20G"
}

variable "http_port" {
  type    = number
  default = 8000
}

//TODO add or set ip address
variable "http_bind_address" {
  type    = string
  default = ""
}

variable "output_directory" {
  type    = string
  default = "build/"
}

variable "vm_cpus" {
  type    = string
  default = "4"
}

variable "vm_description" {
  type    = string
  default = "An Alpine Linux x86_64 operating system"
}

variable "vm_memory" {
  type    = string
  default = "8192"
}

variable "vm_name" {
  type    = string
  default = "alpine"
}

variable "vm_product" {
  type    = string
  default = "Alpine OS"
}

variable "vm_producturl" {
  type    = string
  default = "https://alpinelinux.org/"
}

variable "vm_vendor" {
  type    = string
  default = "Alpine Linux"
}

variable "vm_vendorurl" {
  type    = string
  default = "https://alpinelinux.org/"
}

variable "vm_version" {
  type    = string
  default = "1.0.0.0"
}

variable "vnc_port" {
  type    = number
  default = 5900
}

variable "iso_checksum" {
  type    = string
  default = "file:https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/x86_64/alpine-virt-3.14.3-x86_64.iso.sha256"
}

variable "iso_url" {
  type    = string
  default = "https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/x86_64/alpine-virt-3.14.3-x86_64.iso"
}

variable "qemuargs_device_mac" {
  type    = string
  default = "52:54:00:78:ca:da"
}

variable "qemuargs_netdev_br" {
  type    = string
  default = "kind"
}

//TODO add or set ip address
variable "ssh_host" {
  type    = string
  default = ""
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
# boot_command fix https://github.com/hashicorp/packer/issues/9973
source "qemu" "alpine" {
  accelerator       = "${var.accelerator}"
  boot_command      = [
    "root<enter><wait>", 
    "ifconfig eth0 up && udhcpc -i eth0<enter><wait10>", 
    "wget http://${var.http_bind_address}:{{ .HTTPPort }}/answers<enter><wait>", 
    "setup-alpine -f $PWD/answers<enter><wait5>", 
    //TODO replace 'password' with real password
    "password<enter><wait>", 
    "password<enter><wait>", 
    "<wait10>", 
    "y<enter>", 
    "<wait20>", 
    "rc-service sshd stop<enter>", 
    "mount /dev/vda2 /mnt<enter>", 
    "echo 'PermitRootLogin yes' >> /mnt/etc/ssh/sshd_config<enter>", 
    "umount /mnt<enter>", 
    "reboot<enter>"]
  boot_wait         = "10s"
  communicator      = "ssh"
  disk_interface    = "virtio"
  disk_size         = "${var.disk_size}"
  format            = "qcow2"
  headless          = true
  http_bind_address = "${var.http_bind_address}"
  http_directory    = "http"
  http_port_max     = "${var.http_port}"
  http_port_min     = "${var.http_port}"
  iso_checksum      = "${var.iso_checksum}"
  iso_urls          = ["${var.iso_url}"]
  net_device        = "virtio-net"
  output_directory  = "${var.output_directory}"
  qemu_binary       = "/usr/libexec/qemu-kvm"
  qemuargs          = [
    ["-display","none"],
    ["-device","virtio-net,netdev=user.0,mac=${var.qemuargs_device_mac}"],
    ["-netdev","bridge,id=user.0,br=${var.qemuargs_netdev_br}"]
  ]
  shutdown_command  = "/sbin/poweroff"
  skip_nat_mapping  = true
  ssh_host          = "${var.ssh_host}"
  //TODO replace "password" with real password
  ssh_password      = "password"
  ssh_username      = "root"
  ssh_wait_timeout  = "10m"
  ssh_port          = "22"
  vm_name           = "${var.vm_name}"
  vnc_port_max      = "${var.vnc_port}"
  vnc_port_min      = "${var.vnc_port}"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  description = "An Alpine Linux x86_64 operating system"
  name = "base"

  provisioner "shell" {
    scripts = [
      "scripts/00-configure-base.sh", 
      "scripts/10-install-packages.sh", 
      "scripts/20-configure-networking.sh", 
      "scripts/25-configure-sshd.sh", 
      "scripts/30-configure-users.sh", 
      "scripts/99-minimize-disk.sh"]
  }

  sources = ["source.qemu.alpine"]
}

# Example:
#TODO insert http_bind_address ip address
#TODO insert ssh_host ip address
#packer build \
#-var 'http_bind_address=' \
#-var 'output_directory=/mnt/data/kvm/images' \
#-var 'qemuargs_device_mac=52:54:00:72:7a:89' \
#-var 'qemuargs_netdev_br=minikube' \
#-var 'ssh_host=' \
#-var 'vm_name=minikube' \
#build.pkr.hcl
