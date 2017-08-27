#! /usr/bin/env python2.7
"""
Created on Tue May 16 2017
@author: Paulo Renato
e-mail: prenato@gmail.com
version: 0.1
"""

# Use ADAL library to authenticate with Azure
import adal

tenant_id= 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
application_id= 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeee'
application_secret= 'FakePW$1'

authentication_endpoint = 'https://login.microsoftonline.com/'
resource  = 'https://management.core.windows.net/'

# get an Azure access token using the adal library
context = adal.AuthenticationContext(authentication_endpoint + tenant_id)
token_response = context.acquire_token_with_client_credentials(resource, application_id, application_secret)

access_token = token_response.get('accessToken')
print(access_token)
