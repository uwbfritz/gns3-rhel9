# Developer Notes

This document contains information on the build. 

## SELINUX
SELINUX is disabled in the script. This is because it is not possible to run GNS3 with SELINUX enabled. 


## Firewalld
Firewalld is enabled. GNS3 ports are opened in the script. Docker on RHEL doesn't work well without firewalld.
