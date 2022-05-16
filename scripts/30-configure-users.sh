set -exu

adduser -s /bin/bash -D alpine
#TODO insert password after "alpine:"
echo "alpine:" | chpasswd

mkdir -pm 700 /home/alpine/.ssh

chown -R alpine:alpine /home/alpine/.ssh
chmod -R go-rwsx /home/alpine/.ssh

adduser alpine wheel

echo "Defaults exempt_group=wheel" > /etc/sudoers
echo "%wheel ALL=NOPASSWD:ALL" >> /etc/sudoers
