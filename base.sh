#/usr/bin/env bash

set -x

USERNAME=pthomison

dhclient

dnf update -y

dnf -y install \
sudo \
git \
docker \
python3 \
zsh \
bind-utils \
wget \
curl \
util-linux-user \
htop \
awscli \
dnf-plugins-core \
NetworkManager \
jq

rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
dnf -y install sublime-text

groupadd wheel
usermod -aG wheel $USERNAME
usermod -aG docker $USERNAME

# passwordless sudo
sed -i 's|%wheel.*ALL=(ALL).*ALL.*$|%wheel ALL=(ALL) NOPASSWD: ALL|g' /etc/sudoers




# disable selinux
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

echo "Set disable_coredump false" >> /etc/sudo.conf

K9S_DIR="/opt/k9s"
mkdir -p $K9S_DIR
pushd $K9S_DIR
wget https://github.com/derailed/k9s/releases/download/0.9.3/k9s_0.9.3_Linux_x86_64.tar.gz
tar -xf k9s_0.9.3_Linux_x86_64.tar.gz
ln -s /opt/k9s/k9s /usr/bin/k9s
popd

HELM_DIR="/opt/helm"
mkdir -p $HELM_DIR
pushd $HELM_DIR
wget https://get.helm.sh/helm-v3.0.2-linux-amd64.tar.gz
tar -xf helm-v3.0.2-linux-amd64.tar.gz
ln -s /opt/helm/linux-amd64/helm /usr/bin/helm
popd

sudo su - $USERNAME

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

sudo su -

chsh $USERNAME -s $(which zsh)

