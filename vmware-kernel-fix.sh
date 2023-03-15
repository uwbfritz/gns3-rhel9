#!/usr/bin/env bash

#---------------------------------------------------------------------------------------------------
#  *                              VmwareKernelFix
#    
#    Author: Bill Fritz
#    Description: Patch kernel modules for VMware Workstation 17.0.1 and sign
#    Last Modified: 2023-03-15
#    
#---------------------------------------------------------------------------------------------------

# Variables
VMWARE_VERSION=workstation-17.0.1
TMP_FOLDER=/tmp/patch-vmware

# Function to install the necessary tools
install_tools() {
  if ! command -v openssl &> /dev/null
  then
      sudo dnf install -y openssl
  fi
}

# Function to patch VMware modules
patch_vmware_modules() {
  # Clone the vmware-host-modules repository into the temporary folder
  rm -fdr $TMP_FOLDER
  mkdir -p $TMP_FOLDER
  cd "$TMP_FOLDER" || exit
  git clone https://github.com/mkubecek/vmware-host-modules.git
  cd "$TMP_FOLDER"/vmware-host-modules || exit
  
  # Check out a specific version of the modules
  git checkout $VMWARE_VERSION
  git fetch
  
  # Compile and install the modules
  make
  sudo make install

  # Fix an issue with the libz.so.1 library
  sudo rm /usr/lib/vmware/lib/libz.so.1/libz.so.1
  sudo ln -s /lib/x86_64-linux-gnu/libz.so.1 /usr/lib/vmware/lib/libz.so.1/libz.so.1
}

# Function to sign the VMware modules
sign_vmware_modules() {
  # Create a directory for the keys and a key pair
  sudo mkdir -p /misc/sign-vmware-modules
  sudo chmod 777 /misc/sign-vmware-modules
  cd /misc/sign-vmware-modules || exit
  openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=MSI/"
  
  # Import the key into the system's database
  chmod 600 MOK.priv
  sudo mokutil --import MOK.der
  
  # Sign each of the VMware module files
  for modfile in $(modinfo -n vmmon vmnet); do
    echo "Signing $modfile"
    /usr/src/kernels/"$(uname -r)"/scripts/sign-file sha256 \
                                  /misc/sign-vmware-modules/MOK.priv \
                                  /misc/sign-vmware-modules/MOK.der "$modfile"
  done
}

main() {
  # Update packages
  sudo dnf update -y

  # Install necessary dependencies and tools
  sudo dnf install -y git make gcc kernel-devel

  # Patch the VMware modules
  patch_vmware_modules

  # Install additional tools like openssl needed to sign Vmware modules
  install_tools

  # Sign the VMware modules
  sign_vmware_modules
}

main