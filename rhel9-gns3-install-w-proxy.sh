#!/usr/bin/env bash

#---------------------------------------------------------------------------------------------------
#  *                              Rhel9-gns3-install-w-proxy
#
#    Author: Bill Fritz
#    Description: The longest of roads...
#    Last Modified: 2023-03-20
#
#---------------------------------------------------------------------------------------------------

# proxy server and port variables
proxy_server="yourproxy"
proxy_port="port"

setup_proxy() {
    if [ "$proxy_server" != "yourproxy" ]; then
        export http_proxy=http://$proxy_server:$proxy_port
        export https_proxy=http://$proxy_server:$proxy_port
        echo "proxy=http://$proxy_server:$proxy_port" | sudo tee -a /etc/dnf/dnf.conf
        pip config set global.proxy http://$proxy_server:$proxy_port
    fi
}

# Update system and disable SELinux
update_system() {
    sudo dnf update
    sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config # change SELinux to disabled in config file
    sudo grubby --update-kernel ALL --args selinux=0                         # add kernel parameter to disable SELinux
}

install_gui_if_not() {
    if [ "$(systemctl get-default)" != graphical.target ]; then
        sudo dnf groupinstall -y "Server with GUI"
        sudo systemctl set-default graphical.target
        sudo systemctl isolate graphical # start GUI
    fi
}

enable_codeready_repo() {
    sudo subscription-manager repos --enable codeready-builder-for-rhel-9-x86_64-rpms
}

required_tools() {
    sudo dnf install -y dnf-plugins-core git wget nano curl openssl tigervnc # install all required tools
    sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
    sudo dnf install -y python3-devel elfutils-libelf-devel libpcap-devel python3-pyqt5-sip python3-qt5 xterm cmake busybox libnsl telnet
    sudo dnf groupinstall -y 'Development Tools'
    if [ "$proxy_server" != "yourproxy" ]; then
        pip config set global.proxy http://$proxy_server:$proxy_port
    fi
}

clone_gns3_sources() {
    cd /usr/local/src || exit
    mkdir gns3
    cd gns3 || exit
    git clone https://github.com/GNS3/gns3-server.git
    git clone https://github.com/GNS3/gns3-gui.git
    git clone https://github.com/GNS3/vpcs.git
    git clone https://github.com/GNS3/dynamips.git
    git clone https://github.com/GNS3/ubridge.git
}

install_pip_requirements() {
    sudo python3 -m pip install --upgrade pip
    cd /usr/local/src/gns3/gns3-server/ || exit
    sudo pip3 install -r requirements.txt
    sudo python3 setup.py install
    cd /usr/local/src/gns3/gns3-gui/ || exit
    pip3 install -r requirements.txt
    python3 setup.py install
}

configure_desktop_entry() {
    cp resources/linux/applications/gns3.desktop /usr/share/applications/
    cp -R resources/linux/icons/hicolor/ /usr/share/icons/
}

install_vpcs() {
    cd /usr/local/src/gns3/vpcs/src || exit
    ./mk.sh
    sudo cp vpcs /usr/local/bin/vpcs
}

install_dynamips() {
    cd /usr/local/src/gns3/dynamips/ || exit
    mkdir build
    cd build/ || exit
    cmake ..
    make
    sudo make install
}

install_ubridge() {
    cd /usr/local/src/gns3/ubridge || exit
    make
    sudo make install
}

docker_setup() {
    sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
    sudo dnf -y install docker-ce docker-ce-cli containerd.io
    sudo systemctl enable --now docker
    sudo usermod -aG docker "$(whoami)"
}

libvirt_setup() {
    sudo dnf install -y libvirt qemu-kvm
    sudo usermod -aG libvirt "$(whoami)"
    sudo usermod -aG kvm "$(whoami)"
    sudo systemctl enable --now libvirtd
    sudo systemctl enable --now virtlogd
}

gns3_registry_install() {
    sudo git clone https://github.com/GNS3/gns3-registry.git /usr/local/share/gns3/gns3-registry
    sudo chmod -R 777 /usr/local/share/gns3/gns3-registry
}

sysctl_mods() {
    sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
    sudo sed -i 's/#net.bridge.bridge-nf-call-iptables=1/net.bridge.bridge-nf-call-iptables=1/g' /etc/sysctl.conf
}

misc_setup() {
    sudo ln -s /usr/libexec/qemu-kvm /usr/bin/qemu-kvm
    firewall-cmd --permanent --add-port=3080/tcp
    firewall-cmd --reload
}

xrdp_setup() {
    sudo dnf install -y xrdp
    sudo systemctl enable --now xrdp
    sudo firewall-cmd --permanent --add-port=3389/tcp
    sudo firewall-cmd --reload
    echo gnome-session >~/.xsession
}

function comp_reboot() {
  echo -e "\033[32mInstallation is complete!\033[0m"
  echo -e "\033[33mMachine will reboot in 60 seconds unless you stop it.\033[0m"
  sleep 60
  reboot
}


main() {
    setup_proxy
    update_system
    install_gui_if_not
    enable_codeready_repo
    required_tools
    clone_gns3_sources
    install_pip_requirements
    configure_desktop_entry
    install_vpcs
    install_dynamips
    install_ubridge
    docker_setup
    libvirt_setup
    sysctl_mods
    gns3_registry_install
    misc_setup
    xrdp_setup
    comp_reboot
}

main
