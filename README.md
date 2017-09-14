This project will be a collection of scripts I write for automating the setup of VMs in a vSphere cluster

# set_ips.ps1 script

This script will allow you to set IP Addresses for a large number of VMs using powerclicore. It was written for a specific project I had but could be extended to suit your needs. 

### Script expects a few variables:

$folders - This folders variable is a comma separated list of folders in vSphere. This is used to create an array of folders to search for VMs that need their IP set

$IP_PREFIX - PREFIX you want to use for IPs for all of your VMs

$SNM - Subnet Mask you want to use for IPs for all of your VMs

$GW - Gateway you want to use for IPs for all of your VMs

$vsphere_url - Your vSphere URL


## Running the Script
Once you have all of this setup, you can simply run the scipt and it will prompt you for any other inputs it needs. 

### Naming Conventions

This script will look for VMs that follow a specific naming convention and set their IPs accordingly. 

Linux VMs that match these naming conventions will use function Set-LXVMIP

KA - Kali Linux
UB - Ubuntu Desktop
US - Ubuntu Server

Windows VMs that match these naming conventions will use function WinVMIP
WS - Windows Server 2012
W7 - Windows 7
FS - Windows Server 2012


## Other Inputs

This script will ask for a few different inputs. You'll need to input the Adapter name of the Host VM. 

### Linux Adapter

This is eth0 by default. 

### Windows Adapter

This is Local Area Connection by default.

 
