#!/bin/sh

set -e

curl -s https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public | sudo apt-key add -
sudo curl -s -o /etc/apt/sources.list.d/draios.list http://download.draios.com/stable/deb/draios.list
sudo apt-get update
sudo apt-get -y install linux-headers-$(uname -r)
sudo apt-get -y install draios-agent
sudo sh -c "echo customerid: 5f752882-e4f8-4b2f-81fe-9a3396c96974 >> /opt/draios/etc/dragent.yaml"
sudo sh -c "echo tags: [role:consul,group:bb1] >> /opt/draios/etc/dragent.yaml"
sudo service dragent restart
