#!/bin/bash
#__website__     = "www.seetatech.com"
#__author__      = "seetatech"
#__editor__      = "xuboxuan"
#__Date__        = "20171022"

echo "please enter your password:"
read PASSWORD

s_pwd=$PWD

echo "begin install nvidia-drivers:"
echo $PASSWORD | sudo apt-get purge nvidia-*
echo $PASSWORD | sudo add-apt-repository -y ppa:graphics-drivers/ppa
echo $PASSWORD | sudo apt-get update
echo $PASSWORD | sudo apt-get -y install nvidia-387
echo "finish install nvidia-drivers..."


echo "create seetaas account"
echo $PASSWORD | sudo sudo useradd -m -p `openssl passwd -1 -salt 'seetatech'  seetatech` seetaas
echo $PASSWORD | sudo mkdir /home/seetaas/install
echo $PASSWORD | sudo chown -R seetaas.seetaas /home/seetaas/install

echo "begin install docker-ce:"
echo $PASSWORD | sudo sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common vim git wget
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo $PASSWORD | sudo sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
echo $PASSWORD | sudo sudo apt-get update
echo $PASSWORD | sudo sudo apt-get -y install docker-ce
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://8ad7943c.m.daocloud.io
echo $PASSWORD | sudo sudo systemctl restart docker
echo "finish install docker-ce..."

echo "begin install nvidia-docker:" 
sudo apt-get install nvidia-modprobe

wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker_1.0.1-1_amd64.deb
echo $PASSWORD | sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb
echo $PASSWORD | sudo nvidia-docker run --rm nvidia/cuda nvidia-smi
echo $PASSWORD | sudo sudo sed -i "s/-s \$SOCK_DIR/-s \$SOCK_DIR -l 0.0.0.0:3476/g" /lib/systemd/system/nvidia-docker.service

echo "finish install nvidia-docker..." 

echo $PASSWORD | sudo systemctl daemon-reload
echo $PASSWORD | sudo service nvidia-docker restart
echo $PASSWORD | sudo service nvidia-docker status

echo "begin install mesos:"
echo $PASSWORD | sudo apt-get -y install build-essential python-dev python-boto libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev libsvn-dev
echo $PASSWORD | sudo apt-get install zlib1g-dev
echo $PASSWORD | sudo apt-get install -y autoconf libtool

wget -c ftp://192.168.1.186/pub/jdk-8u144-linux-x64.tar.gz
echo $PASSWORD | sudo tar -zxvf jdk-8u144-linux-x64.tar.gz -C /usr/local
echo $PASSWORD | sudo sh -c "echo export JAVA_HOME=/usr/local/jdk1.8.0_144 >> /etc/profile.d/java.sh"
echo $PASSWORD | sudo sh -c "echo export JRE_HOME=/usr/local/jdk1.8.0_144/jre >> /etc/profile.d/java.sh"
echo $PASSWORD | sudo sh -c "echo export CLASSPATH=.:\"$\"JAVA_HOME/lib/dt.jar:\"$\"JAVA_HOME/lib/tools.jar:\"$\"JRE_HOME/lib:\"$\"CLASSPATH >> /etc/profile.d/java.sh"
echo $PASSWORD | sudo sh -c "echo export PATH=\"$\"JAVA_HOME/bin:\"$\"PATH >> /etc/profile.d/java.sh"
source /etc/profile

wget -c ftp://120.25.103.102/pub/mesos-1.4.0.tar.gz

tar zxvf mesos-1.4.0.tar.gz

cd mesos-1.4.0

mkdir build
cd build
../configure
make -j4
echo $PASSWORD | sudo make install

echo "environment install success,please restart your computer,then grant seetaas sudo permissions..."