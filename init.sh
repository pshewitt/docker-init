#!/bin/bash


function error_msg {
 echo "----> error with \"$1 $2\", exiting"
 exit 1 
}

#setup environment
groupadd -g 44 video
groupadd -g 143 hts
groupadd -g 33 www-data
useradd -M -g 143 -u 128 -s /usr/sbin/nologin hts
useradd -M -g 33 -u 33 -s /usr/sbin/nologin www-data

#install docker
if [ ! -f /usr/bin/docker ]; then
curl -fsSL get.docker.com -o get-docker.sh | sh get-docker.sh || sh get-docker.sh
fi

#install docker-compose & git
if [ -f /usr/bin/yum ]; then 
  yum -y upgrade || error_msg yum upgrade
  yum -y install epel-release  || error_msg yum epel-release
  yum -y install git  || error_msg yum git
  yum -y install docker-compose  || error_msg yum docker-compose
elif [ -f /usr/bin/apt ]; then
  apt -y update || error_msg apt update
  apt -y upgrade || error_msg apt upgrade
  apt -y install git || error_msg apt git
  apt -y install docker-compose || error_msg apt docker-compose
fi
mkdir -p /tmp/git ; cd /tmp/git
git -C /tmp/git clone https://pshewitt:B1ltong\!@github.com/pshewitt/docker-init.git
docker-compose -f /tmp/git/docker-init/docker-compose.yml up -d || error_msg docker-compose up
