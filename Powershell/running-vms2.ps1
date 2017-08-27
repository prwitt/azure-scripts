<#
    Description: This script lists all the VMs from the subscriptions a user has access to,
    and create a CSV file with relevant information.
    Created on: Jan. 5, 2017
    Authours: Paulo Renato
    Version: 0.1 
#>
get-date

$subscriptions = Get-AzurermSubscription

foreach ($sub in $subscriptions)
{

    Select-AzurermSubscription -SubscriptionId $sub
 
    $VMS = Get-AzureRmVM -Status
 
    $vmname = $VMS.Name

    foreach($vm in $vmname)
    {
        $rgname = ($VMS | where-object -Property Name -EQ $vm).ResourceGroupName
        $location = ($VMS | where-object -Property Name -EQ $vm).Location
        $ostype = ($VMS | where-object -Property Name -EQ $vm).StorageProfile.OsDisk.OsType
        $status =  ($VMS | where-object -Property Name -EQ $vm).PowerState
   
        Write-Output  "$($sub.SubscriptionName),$rgname,$vm,$location,$ostype,$status" | Out-File -Append -FilePath  "c:\Temp\AzureVMInfo_TEST2.csv"

    }
 
}
get-date
