#!/bin/bash
#
# Created on Mar 28 2017
# @author: Paulo Renato
# e-mail: prenato@gmail.com
# version: 0.1 
#
# Before Starting:
# Set variables corresponding to your environment
#
VMname="vm1-sandbox2"
VMsize="Standard_DS1"
#az vm sizes --location $location, to list the sizes that are available
IMAGEname="/subscriptions/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee/resourceGroups/rg-mygoldenimgs/providers/Microsoft.Compute/images/CentOS7mini"
#az vm image list
location="westus"
RGname="rg-tags"
ASname="as-sandbox2"
ASFAULTcount="2"
ASUPDATEcount="2"
VNETname="vnet-sandbox2"
VNETprefix="172.23.0.0/16"
SUBNETname="subnet1-sandbox2"
SUBNETprefix="172.23.1.0/24"
PIPname="pip-sandbox2-${VMname}"
PIPallocation="Dynamic"
NICname="nic-${VMname}"
ADMINuser="mysername"
ADMINpassword="FakePassWord@1"
TAGpair="AppOwner=AppOwnerName"

function create_RG {
#Create necessary resources for VMs
	echo Creating Resource Group
	echo
	az group create --name $RGname \
    --location $location
}

function create_AS {
#Create Availability Set
	echo Creating Availability Set
	echo
	az vm availability-set create --platform-fault-domain-count $ASFAULTcount \
    --platform-update-domain-count $ASUPDATEcount \
    --name $ASname \
    --resource-group $RGname \
    --tags $TAGpair \
    --location $location
}

function create_VNET {
#Create VNET
	echo Creating VNET
	echo
	az network vnet create --resource-group $RGname \
    --name $VNETname \
    --location $location \
    --tags $TAGpair \
    --address-prefixes $VNETprefix
}

function create_SUBNET {
#Create Subnet
	echo Creating Subnet
	echo
	az network vnet subnet create --resource-group $RGname \
    --name $SUBNETname \
    --vnet-name $VNETname \
    --address-prefix $SUBNETprefix
}

function create_PIP {
#Crete Public IP
	echo Creating Public IP
	echo
	azure network public-ip create --resource-group $RGname \
    --name $PIPname \
    --location $location \
    --tags $TAGpair \
    --allocation-method $PIPallocation
}

function create_NIC {
#Create NIC
	echo Creating NIC
	echo
	az network	nic create --name $NICname \
	--resource-group $RGname \
	--subnet $SUBNETname \
	--vnet-name $VNETname \
	--location $location \
    --tags $TAGpair \
	--public-ip-address $PIPname
}

function create_VM {
#Create the VM
	echo Creating	VM
	echo
	az vm create --resource-group $RGname \
	--name $VMname \
	--location $location \
	--size $VMsize \
	--availability-set $ASname \
	--nics $NICname \
	--image $IMAGEname \
    --tags $TAGpair
    #--admin-username $ADMINuser \
    #--admin-password $ADMINpassword
}

#create_RG
create_AS
create_VNET
create_SUBNET
create_PIP
create_NIC
create_VM
