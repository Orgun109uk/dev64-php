#!/bin/bash -e

apt-get -y install curl vim software-properties-common python-software-properties build-essential make
apt-get -y purge apparmor libapparmor1

touch /home/vagrant/.gitconfig
chown vagrant:vagrant /home/vagrant/.gitconfig
echo "[url \"https://\"]" >> /home/vagrant/.gitconfig
echo "        insteadOf = git://" >> /home/vagrant/.gitconfig

echo "Installing GIT..."
add-apt-repository ppa:git-core/ppa -y
apt-get -y install git-core

echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /home/vagrant/.ssh/config
echo "Host github.com (192.30.252.131)\n\tStrictHostKeyChecking no\n" >> /home/vagrant/.ssh/config
ssh-keyscan github.com >> /home/vagrant/.ssh/known_hosts 2>/dev/null;

echo "" >> /home/vagrant/.bashrc
echo "parse_git_branch() {" >> /home/vagrant/.bashrc
echo "   [ -d .git ] && git name-rev --name-only @" >> /home/vagrant/.bashrc
echo "}" >> /home/vagrant/.bashrc
echo "PS1='\\e];\\s\\a\\e[33m\\w \\e[36m\$(parse_git_branch)\\e[m \$ '" >> /home/vagrant/.bashrc
echo "" >> /home/vagrant/.bashrc

mkdir /home/vagrant/startups
chown vagrant:vagrant /home/vagrant/startups
