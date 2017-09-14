Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false


#Variables for this script to run
#-------------------------#
#*************************#

#This folders variable is a comma separated list in order to create an array of folders
$folders = "","",""

#PREFIX you want to use for IPs
$IP_PREFIX = "10.0.0."

#Subnet Mask
$SNM = "255.255.255.0"

#Gateway. This is actually required for things like the netsh script in windows
$GW = "10.0.0.1"

#Set vsphere uRL
$vsphere_url = ""

#*************************#
#-------------------------#

#Function for setting Windows 7 IP Address
Function Set-WinVMIP ($VM, $HC, $GC, $IP, $SNM, $GW, $ADAPTER){
 $netsh = "c:\windows\system32\netsh.exe interface ip set address name=`"$ADAPTER`" static $IP $SNM $GW"
 Write-Host "Setting IP address for $VM..."
 Invoke-VMScript -VM $VM -GuestCredential $GC -ScriptType bat -ScriptText $netsh
 Write-Host "Setting IP address completed."
}


#Function for setting Ubuntu IP Address
Function Set-UBVMIP ($VM, $HC, $GC, $IP, $SNM, $GW, $ADAPTER){
 $ifconfig = "sudo ifconfig $ADAPTER $IP $SNM $GW"
 Write-Host "Setting IP address for $VM..."
 Invoke-VMScript -VM $VM -GuestCredential $GC -ScriptType bat -ScriptText $ifconfig
 Write-Host "Setting IP address completed."
}

#Function to turn on a VM. Not really needed in this script yet, but could be used to power on VMs before setting adapter
Function PowerOn ($VM)
{
 Start-VM -VM $VM
}

#Get vSphere Credentials
$HostCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter vSphere credentials", "", "")

#Get Windows 7 Credentials. Could hardcore these, but I try not to store passwords
$WIN7GuestCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter Windows admin credentials:", "admin", "")

#Get the name of the Adapter we want to set on all VMs
$WIN7Adapter = Read-Host -Prompt 'Input your Windows Network Adapter Name (ex. Local Area Connection 4)'

#Get Ubuntu Credentials. Could hardcode these, but again I try not to store passwords
$UBGuestCred = $Host.UI.PromptForCredential("Please enter credentials", "Enter Ubuntu root credentials:", "root", "")

#Get the name of the Adapter we want to set on all VMs
$UBAdapter = Read-Host -Prompt 'Input your Ubuntu Network Adapter Name (ex. eth0)'


#Connect to vSphere
Connect-VIServer -Server $vsphere_url

#For each folder you specified in the array, do some things
Foreach($folder in $folders) {

#create a counter for IP suffix. This way we can dynamically set IPs and don't overlap them
$ip_counter = 1

#Set Windows 7 IPs
#----------------------#

#Get all W7 VMS
$WIN7VMS = Get-Folder $folder | Get-VM '*W7*'

Foreach ($VM IN $WIN7VMS) {
$ip_counter++
$IP = $IP_PREFIX+$ip_counter
Set-WinVMIP $VM $HostCred $WIN7GuestCred $IP $SNM $GW $WIN7Adapter

}
#---------------------#



#Set UB IPs
#---------------------#

#Get all UB VMS
$UBVMS = Get-Folder $folder | Get-VM '*UB*'

#Set IPs in all UB VMs
Foreach ($VM IN $UBVMS) {
$ip_counter++
$IP = $IP_PREFIX+$ip_counter
Set-UBVMIP $VM $HostCred $UBGuestCred $IP $SNM $GW $UBAdapter
#---------------------#
}
}
