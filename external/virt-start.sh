#!/usr/bin/env bash

printf "\n==> Install: \n"

#virt-install --name alpine \
#--vcpus 4 \
#--memory 16384 \
#--disk path=builds/alpine \
#--os-variant alpinelinux3.13 \
#--network network=kind,model=virtio,mac=52:54:00:78:ca:da \
#--rng /dev/urandom \
#--graphics none \
#--console pty,target_type=virtio \
#--noautoconsole \
#--boot hd

#TODO insert ip adress to alpine@
#TODO insert ip adress to password:
printf "\n==> Usage:\n\e[1;36mssh alpine@ \nalpine@'s password: \e[0m \n"

exit 0
