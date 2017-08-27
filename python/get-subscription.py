#! /usr/bin/env python2.7
"""
Created on October 19 2016
@author: Paulo Renato
e-mail: prenato@gmail.com
version: 0.1
"""
import adal
import requests

authentication_endpoint = 'https://login.microsoftonline.com/'
resource  = 'https://management.core.windows.net/'
tenant_id= 'a6ea6fa8-b12f-44b5-b319-7956bcd4c58c'
application_id= '60b63507-8600-4886-a876-ff57bd524358'
application_secret= 'Welcome_123!'

# get an Azure access token using the adal library
context = adal.AuthenticationContext(authentication_endpoint + tenant_id)
token_response = context.acquire_token_with_client_credentials(resource, application_id, application_secret)

access_token = token_response.get('accessToken')

endpoint = 'https://management.azure.com/subscriptions/?api-version=2015-01-01'

headers = {"Authorization": 'Bearer ' + access_token}
json_output = requests.get(endpoint,headers=headers).json()
for sub in json_output["value"]:
    print(sub["displayName"] + ': ' + sub["subscriptionId"])
