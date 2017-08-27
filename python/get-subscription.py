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
tenant_id= 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
application_id= 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
application_secret= 'FakePW!23'

# get an Azure access token using the adal library
context = adal.AuthenticationContext(authentication_endpoint + tenant_id)
token_response = context.acquire_token_with_client_credentials(resource, application_id, application_secret)

access_token = token_response.get('accessToken')

endpoint = 'https://management.azure.com/subscriptions/?api-version=2015-01-01'

headers = {"Authorization": 'Bearer ' + access_token}
json_output = requests.get(endpoint,headers=headers).json()
for sub in json_output["value"]:
    print(sub["displayName"] + ': ' + sub["subscriptionId"])
