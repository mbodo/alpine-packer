set -eux

sudo apk update && apk add sshfs

touch /etc/modules-load.d/fuse.conf
echo "fuse" >> /etc/modules-load.d/fuse.conf
