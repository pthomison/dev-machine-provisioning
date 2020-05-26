#/usr/bin/env bash

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

source ${SCRIPTS_DIR}/base.sh

dnf install cros-guest-tools 

systemctl unmask systemd-logind
loginctl enable-linger $USERNAME

systemctl enable cros-sftp

mkdir -p ~/.ssh
mkdir -p ~/.aws

rm /home/pthomison/.zshrc /home/pthomison/.gitconfig /home/pthomison/.ssh/config || true

ln -s /mnt/chromeos/MyFiles/Configs/zsh/zshrc /home/pthomison/.zshrc
ln -s /mnt/chromeos/MyFiles/Configs/git/gitconfig /home/pthomison/.gitconfig
ln -s /mnt/chromeos/MyFiles/Configs/ssh/config /home/pthomison/.ssh/config
ln -s /mnt/chromeos/MyFiles/Configs/aws/config /home/pthomison/.aws/config
ln -s /mnt/chromeos/MyFiles/Configs/aws/credentials /home/pthomison/.aws/credentials

sudo su - $USERNAME

systemctl --user enable sommelier@0 sommelier-x@0 sommelier@1 sommelier-x@1 cros-garcon cros-pulse-config

sudo su -

dhclient
systemctl disable systemd-networkd
systemctl disable systemd-resolved
systemctl enable NetworkManager
unlink /etc/resolv.conf