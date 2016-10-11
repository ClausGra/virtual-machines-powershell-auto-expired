<#
	The sample scripts are not supported under any Microsoft standard support 
	program or service. The sample scripts are provided AS IS without warranty  
	of any kind. Microsoft further disclaims all implied warranties including,  
	without limitation, any implied warranties of merchantability or of fitness for 
	a particular purpose. The entire risk arising out of the use or performance of  
	the sample scripts and documentation remains with you. In no event shall 
	Microsoft, its authors, or anyone Else involved in the creation, production, or 
	delivery of the scripts be liable for any damages whatsoever (including, 
	without limitation, damages for loss of business profits, business interruption, 
	loss of business information, or other pecuniary loss) arising out of the use 
	of or inability to use the sample scripts or documentation, even If Microsoft 
	has been advised of the possibility of such damages 
#>

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
