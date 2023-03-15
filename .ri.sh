#!/usr/bin/env bash

#---------------------------------------------------------------------------------------------------
#  *                              Rhel9-gns3-install
#    
#    Author: Bill Fritz
#    Description: The longest of roads...
#    Last Modified: 2023-03-15
#    
#---------------------------------------------------------------------------------------------------

sudo dnf update
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sudo grubby --update-kernel ALL --args selinux=0

if [ "$(systemctl get-default)" != graphical.target ]; then
    sudo dnf groupinstall -y "Server with GUI"
    sudo systemctl set-default graphical.target
    sudo systemctl isolate graphical
fi

sudo subscription-manager repos --enable codeready-builder-for-rhel-9-x86_64-rpms
sudo dnf install -y dnf-plugins-core git wget nano curl
sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
sudo dnf install -y python3-devel elfutils-libelf-devel libpcap-devel python3-pyqt5-sip python3-qt5 xterm cmake busybox libnsl telnet
sudo dnf groupinstall -y 'Development Tools'
cd /usr/local/src || exit
mkdir gns3
cd gns3 || exit
git clone https://github.com/GNS3/gns3-server.git
git clone https://github.com/GNS3/gns3-gui.git
git clone https://github.com/GNS3/vpcs.git
git clone https://github.com/GNS3/dynamips.git
git clone https://github.com/GNS3/ubridge.git
sudo python3 -m pip install --upgrade pip
cd /usr/local/src/gns3/gns3-server/ || exit
sudo pip3 install -r requirements.txt
sudo python3 setup.py install
cd /usr/local/src/gns3/gns3-gui/ || exit
pip3 install -r requirements.txt
python3 setup.py install
cp resources/linux/applications/gns3.desktop /usr/share/applications/
cp -R resources/linux/icons/hicolor/ /usr/share/icons/
cd /usr/local/src/gns3/vpcs/src || exit
./mk.sh
sudo cp vpcs /usr/local/bin/vpcs
cd /usr/local/src/gns3/dynamips/ || exit
mkdir build 
cd build/ || exit
cmake ..
make
sudo make install
cd /usr/local/src/gns3/ubridge || exit
make
sudo make install

sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io 
sudo systemctl enable --now docker
sudo usermod -aG docker "$(whoami)"
sudo dnf install -y libvirt qemu-kvm
sudo usermod -aG libvirt "$(whoami)"
sudo usermod -aG kvm "$(whoami)"
sudo usermod -aG docker "$(whoami)"
sudo systemctl enable --now libvirtd
sudo systemctl enable --now virtlogd
sudo chmod 777 /var/run/docker.sock
sudo git clone https://github.com/GNS3/gns3-registry.git /usr/local/share/gns3/gns3-registry
sudo chmod -R 777 /usr/local/share/gns3/gns3-registry
sudo ln -s /usr/libexec/qemu-kvm /usr/bin/qemu-kvm
firewall-cmd --permanent --add-port=3080/tcp
firewall-cmd --reload