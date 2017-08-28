<#
    Description: This script changes a VM IP address
    Created on: Mar. 15, 2017
    Authours: Paulo Renato 
    Version: 0.1
#>

# Update the following variables to Reflect your environment

$RGname = "rg-source"
$NICname = "vm-testnic673"
$VNETname = "rg-source-vnet"
$TargetVNETname = "rg-destination-vnet"
$TargetSubnetName = "default"
$VMName = "vm-testnic"

# The following commands will update the VM IP – Don’t change below here

$VirtualMachine = Get-AzureRmVM -ResourceGroupName $RGname -Name $VMName
$NIC = Get-AzureRmNetworkInterface -Name $NICname -ResourceGroupName $RGname
$CurrentIP = $NIC.IpConfigurations[0].PrivateIpAddress

Write-Host "Current IP is : " $CurrentIP

$VNET = Get-AzureRmVirtualNetwork -Name $VNETname  -ResourceGroupName $RGname
$TargetSubnet = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $VNET -Name $TargetSubnetName
$NIC.IpConfigurations[0].Subnet.Id = $TargetSubnet.Id
Set-AzureRmNetworkInterface -NetworkInterface $NIC
Update-AzureRmVM -VM $VirtualMachine -ResourceGroupName $RGname
$NewIP = $(Get-AzureRmNetworkInterface -Name $NICname -ResourceGroupName $RGname).IpConfigurations[0].PrivateIpAddress

Write-Host "New IP is : " $NewIP