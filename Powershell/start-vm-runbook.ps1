<#
    Description: This runbook starts VMs from a given subscription by using Azure Automation.
    Created on: May. 5, 2017
    Authours: Paulo Renato
    Version: 0.1 
#>
$Conn = Get-AutomationConnection -Name AzureRunAsConnection
Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID `
-ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

$Allvms=Get-AzureRmVM

$AllvmsName=$Allvms.Name

# You can manually set the following variable with the VM names you want this script to start.
#$AllvmsName ="my-vm1"

ForEach ($SingleVM in $AllvmsName){
    $VMRGName = ($Allvms | Where-Object -Property Name -EQ $SingleVM).ResourceGroupName
    $VMstatus = (Get-AzureRmVM -Name $SingleVM -ResourceGroupName $VMRGName -Status).Statuses[1].DisplayStatus

    if ( $VMstatus -EQ "VM deallocated") {
        write-host "Starting VM"
        Start-AzureRmVM -Name $SingleVM -ResourceGroupName $VMRGName
    }
    else {
        write-host "VM is already Running"
    }
}