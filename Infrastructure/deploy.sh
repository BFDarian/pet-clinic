#!bin/bash/
sudo apt-get update
sudo apt install curl -y
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz"| tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
curl -LO https://storage.googleapis.com/kubernetes-release/release/%60curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt%60/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
curl https://get.docker.com/ | sudo bash
sudo usermod -aG docker $(jenkins)
git clone repo
cd into repo
run docker-compose