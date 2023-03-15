RHEL9 GNS3 Installation Script
This script installs and configures the necessary components to run GNS3 on Red Hat Enterprise Linux 9.

System Requirements
Red Hat Enterprise Linux (RHEL) 9
Access to the internet
Usage
Download the rhel9-gns3-install file.
Open a terminal window and navigate to the directory where you saved the file.
Make the file executable by running the following command:
Copy
Insert
New
chmod +x rhel9-gns3-install
Run the script with the following command:
Copy
Insert
New
./rhel9-gns3-install
What it does
Updates the system and disables SELinux.
Installs GUI if not already installed.
Enables the CodeReady Builder repository.
Installs all required tools for GNS3.
Clones the GNS3 server, GUI, and related repositories into /usr/local/src/gns3.
Installs Python packages required by GNS3.
Configures the desktop shortcut in GNOME.
Installs VPCS, Dynamips, and Ubridge.
Sets up Docker and libvirt.
Installs the GNS3 registry.
Configures miscellaneous settings.
Note: This script requires superuser privileges to install software and make changes to the system.