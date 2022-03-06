##storage_devices_vms.bat
#Oracle VM VirtualBox can open VMware native virtual machine hard drive files in .vmdk format.
#This doesn't work other way around though - WMware can't open VirtualBox .vdi files.
#If you have Oracle VirtualBox installed you can easily convert .vdi to .vmdk using command line VBoxManage.exe tool:
#Go to C:\Program Files\Oracle\VirtualBox and open VBoxManage.exe in command prompt.
#Run following command to convert .vmi file to .vmdk:
clonehd D:\Ubuntu.vdi D:\Ubuntu.vmdk -format VMDK -variant standard
#This will convert D:\Ubuntu.vdi to D:\Ubuntu.vmdk