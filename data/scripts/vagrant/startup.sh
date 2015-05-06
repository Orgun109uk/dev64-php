#!/bin/bash -e

sudo su vagrant <<'EOF'
echo "Init NVM..."
export NVM_DIR="/usr/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

echo "Run startup scripts..."
for SCRIPT in `ls -v /home/vagrant/startups/*`; do
  if [ -f $SCRIPT -a -x $SCRIPT ]; then
    $SCRIPT
  fi
done
EOF

IPADDR=$(ifconfig eth1|xargs|awk '{print $7}'|sed -e 's/[a-z]*:/''/')

echo " "
echo "**********************************************************************"
echo "* PHP Development Environment"
echo "**********************************************************************"
echo "* Workspace: /home/vagrant/workspace -> %VAGRANT%\workspace"
echo "**********************************************************************"
echo "* Tools:"
echo "*   - Cloud9 IDE: http://${IPADDR}:8181"
echo "*   - Adminer (DB): http://${IPADDR}:8081"
echo "*   - MailDev (Mail SMTP): http://${IPADDR}:1080"
echo "**********************************************************************"
echo "* Credentials:"
echo "*    Ubuntu: vagrant - vagrant"
echo "*    MySQL: root - vagrant"
echo "**********************************************************************"
echo " "
