#!/usr/bin/env bash

pushd external

virsh net-create kind-net.xml
# To be able to enable autostart the 
# virsh net-edit kind needs to be started and 
# at the end of xml add the empty line then save
# autostart the will be enbled
#
# Example:
# virsh net-edit kind
# <CR>G
# o<Esc>
# !wqa
#
# Than execute the $virsh net-edit kind
virsh net-autostart kind

#https://blog.christophersmart.com/2016/08/31/configuring-qemu-bridge-helper-after-access-denied-by-acl-file-error/
#echo "allow all" | sudo tee /etc/qemu-kvm/${USER}.conf
#echo -e "include /etc/qemu-kvm/${USER}.conf" | sudo tee --append /etc/qemu-kvm/bridge.conf
#sudo chown root:${USER} /etc/qemu-kvm/${USER}.conf
#sudo chmod 640 /etc/qemu-kvm/${USER}.conf
# https://www.fatalerrors.org/a/qemu-kvm-a-tool-for-creating-kvm-virtual-machine.html

popd

exit 0
