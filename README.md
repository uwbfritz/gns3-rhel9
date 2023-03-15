# RHEL9 GNS3 Installation Script
This script installs and configures the necessary components to run GNS3 on Red Hat Enterprise Linux 9.

## System Requirements
- Red Hat Enterprise Linux (RHEL) 9
- Access to the internet

### Usage
- Download the rhel9-gns3-install file.
- Open a terminal window and navigate to the directory where you saved the file.
- Make the file executable by running the following command:
```
chmod +x rhel9-gns3-install.sh
```
- Run the script with the following command:
```
./rhel9-gns3-install.sh
```

### What it does
- Updates the system and disables SELinux.
- Installs Server GUI if not already installed.
- Enables the CodeReady Builder repository.
- Installs all required tools for GNS3.
- Clones the GNS3 server, GUI, and related repositories into /usr/local/src/gns3.
- Installs Python packages required by GNS3.
- Configures the desktop shortcut in GNOME.
- Installs VPCS, Dynamips, and Ubridge.
- Sets up Docker and libvirt.
- Installs the GNS3 registry.
- Configures miscellaneous settings.
**Note:** This script requires superuser privileges to install software and make changes to the system.

# VmwareKernelFix
This script is designed to patch kernel modules for VMware Workstation 17.0.1 and sign the resulting code. 

### Usage
To use this script, simply execute it in a terminal with administrative privileges:

```
sudo ./VmwareKernelFix
```

### Functions
The script has three main functions:

- install_tools: Installs the necessary tools required by the script such as openssl

- patch_vmware_modules: Clones the vmware-host-modules repository into a temporary folder, checks out the specified version, compiles and installs the modules, and then fixes an issue with the libz.so.1 library.

- sign_vmware_modules: This function creates a directory for the keys and a key pair, imports the key into the system's database, and signs each of the VMware module files.

### Variables
The script uses the following variables:

- **VMWARE_VERSION**: Defines the version of VMware Workstation or Player to be patched

- **TMP_FOLDER**: Defines the temporary folder used to clone the vmware-host-modules repository. It defaults to /tmp/patch-vmware
