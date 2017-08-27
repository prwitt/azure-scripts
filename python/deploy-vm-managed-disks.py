#! /usr/bin/env python2.7
"""
Created on Mar 28 2017
@author: Paulo Renato
e-mail: prenato@gmail.com
version: 0.1 
"""

#
# This script deploys a VM with Managed Disk, from a Golden Image hosted on Azure
# As a pre-req, you need to create: Service Principal, Resource Group, VNET, VM Image
#  

from azure.common.credentials import ServicePrincipalCredentials
from azure.mgmt.resource.subscriptions import SubscriptionClient
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.storage import StorageManagementClient
from azure.mgmt.network import NetworkManagementClient
from azure.mgmt.compute import ComputeManagementClient

#
# Variables to change according to your environment
#

credentials = ServicePrincipalCredentials(
    client_id='aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee',
    secret='somepassword',
    tenant='aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
)
subscription_name='Azure Subscription 1'
subscription_id='aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
resource_group='rg-pythondemo'
region='westus'
vmname='pythonvm2'
nicname='pythonvm2nic1'
username='auser'
password='Passw0rd!23'
osdiskname='Pythonvm2OSDISK'

VM_REFERENCE = {
    'linux': {
        'publisher': 'Custom',
        'offer': 'CentOS',
        'sku': 'Custom',
        'version': 'latest'
    },
    'windows': {
        'publisher': 'MicrosoftWindowsServerEssentials',
        'offer': 'WindowsServerEssentials',
        'sku': 'WindowsServerEssentials',
        'version': 'latest'
    }
}

#
# Set Client object
#

resource_client = ResourceManagementClient(credentials, subscription_id)
storage_client = StorageManagementClient(credentials, subscription_id)
network_client = NetworkManagementClient(credentials, subscription_id)
compute_client = ComputeManagementClient(credentials,subscription_id)

getimage=compute_client.images.get('rg-mygoldenimgs','CentOS7mini')

vnets=network_client.virtual_networks.list(resource_group)
print(vnets)
for vnet in vnets:
    subnets=network_client.subnets.list(resource_group,vnet.name)
    for subnet in subnets:
        if (subnet.name=='default'):
            nicsubnetid=subnet.id
            print (nicsubnetid)
        else:
            nicsubnetid=subnet.id
            print (nicsubnetid)

nics=network_client.network_interfaces.create_or_update(resource_group,nicname,{'location': region, 'ip_configurations': [{'name': 'vmipname', 'subnet': {'id': nicsubnetid}}]})
newnic=nics.result()
print(newnic.id)

def create_vm_parameters(nic_id, vm_reference):
    return {
        'location': region,
        'os_profile': {
            'computer_name': vmname,
            'admin_username': username,
            'admin_password': password
        },
        'hardware_profile': {
            'vm_size': 'Standard_DS1'
        },
        'storage_profile': {
            'image_reference': {
                'id': getimage.id
                },
            'os_disk': {
                'name': osdiskname,
                'caching': 'ReadWrite',
                'create_option': 'fromImage',
                'disk_size_gb': 32
            },
        },
        'network_profile': {
            'network_interfaces': [{'id': nic_id,}]
        },
    }
vm_parameters = create_vm_parameters(newnic.id, VM_REFERENCE['linux'])

vm=compute_client.virtual_machines.create_or_update(resource_group,vmname,vm_parameters)
vm.wait()
