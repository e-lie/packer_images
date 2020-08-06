
set -eux

apt-get install -y openssh-server
systemctl restart sshd

groupadd -r admin
# Unsecure packer user to be removed at the end using ansible
useradd -m -s /bin/bash -G admin packer 
echo "packer:packerpasswd" | chpasswd
cp /etc/sudoers /etc/sudoers.orig
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers