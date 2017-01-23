---
services: virtual machines
platforms: powershell
author: msonecode
---

# How to optimize costs by setting expired date for Azure Virtual Machine by PowerShell

## Introduction
This script demonstrates [how to set expired date for Azure Virtual Machine in Dev Labs by PowerShell](https://gallery.technet.microsoft.com/How-to-set-expired-date-of-826800a7).

**Related topics**

- [How to create Azure Virtual Machine (VM) by Powershell using ARM API][1]
- [How to create Azure VM by Powershell using classic ASM API][2]


## Scenarios
Practically, developers often create Azure Virtual Machines in Dev Labs for demo or development purpose. However, those “test” VM instances are also charged. Since nobody remembers to delete them after development, company shall then pay for the instances. Thus, it must be wonderful if those “test” VM instances can be automatically deleted.

Luckily, Microsoft Azure have released new features about [expired date of virtual machine][3] on October 6, 2016. IT pro can make the use of this new feature to optimize costs. And this sample also supplies an OOB script to set expired date for your existed VM instance in Dev Labs.

## Prerequisites
- Install [Azure PowerShell][4]

## Run this sample
- Open the script file SetExpiredDateAzureVM.ps1
- Edit the parameter “-VMName” and “-LabName” and “-ExpiredUTCDate”  
  ```ps1
  Set-AzureVirtualMachineExpiredDate -VMName "vmname" -LabName "labname" -ExpiredUTCDate "2016-10-10"
  ```
 
  Notes: the date is in UTC format
 
- Then run the script in PowerShell console
- After the script finishes its job, you can see the result it's have Azure Virtual Machine infomation. 
![][5]

 
## Script
```ps1
Function Set-AzureVirtualMachineExpiredDate 
{ 
    [CmdletBinding()] 
    Param 
    ( 
        [Parameter(Mandatory=$true)][String]$VMName, 
        [Parameter(Mandatory=$true)][String]$LabName, 
        [Parameter(Mandatory=$true)][DateTime]$ExpiredUTCDate 
    ) 
 
    # get vm info 
    $targetVMInfo = Get-AzureRmResource | Where { $_.Name -eq "$LabName/$VMName" -and $_.ResourceType -eq 'Microsoft.DevTestLab/labs/virtualMachines' } 
 
    # if not find, throw exception 
    If ($targetVMInfo -eq $null) { 
        Throw "No VM naming $VMName" 
    } 
 
    # get vm properties 
    $vmInfoWithProperties = Get-AzureRmResource -ResourceId $targetVMInfo.ResourceId -ExpandProperties 
    $vmProperties = $vmInfoWithProperties.Properties 
 
    # set expired date 
    $vmProperties | Add-Member -MemberType NoteProperty -Name expirationDate -Value $ExpiredUTCDate 
    Set-AzureRmResource -ResourceId $targetVMInfo.ResourceId -Properties $vmProperties -Force 
 
    Write-Host "Successfully to set VM "$LabName/$VMName" to expire on UTC $ExpiredUTCDate" 
} 
 
# 1. login azure 
Login-AzureRmAccount 
 
# 2. fill target vm name, lab name and expired date 
Set-AzureVirtualMachineExpiredDate -VMName "lab-autoexpired" -LabName "eric-lab" -ExpiredUTCDate "2016-10-10" 
```

## Additional Resources
- Azure PowerShell SDK: [https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure](https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure)
- First hand news about “expired date” of Azure Virtual Machine: [https://azure.microsoft.com/en-us/blog/set-expiration-date-for-vms-in-azure-devtest-labs/](https://azure.microsoft.com/en-us/blog/set-expiration-date-for-vms-in-azure-devtest-labs/)
 

[1]: https://gallery.technet.microsoft.com/How-to-create-Azure-VM-by-22f8bea9
[2]: https://gallery.technet.microsoft.com/How-to-create-Azure-VM-by-b894d750
[3]: https://azure.microsoft.com/en-us/blog/set-expiration-date-for-vms-in-azure-devtest-labs/
[4]: https://azure.microsoft.com/en-us/documentation/articles/powershell-install-configure/#step-1-install
[5]: img/1.PNG
