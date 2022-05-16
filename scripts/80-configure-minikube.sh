set -eux

sudo apk update && apk add libc6-compat && apk add conntrack-tools

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube