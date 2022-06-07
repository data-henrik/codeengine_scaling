#!/bin/bash

set -ex

# IBM Cloud login to target resource group and region
# The API key is taken from the environment
ibmcloud login  -g ${ICRESOURCEGROUP} -r ${ICREGION}

# Select the Code Engine project
ibmcloud ce project select --name ${CEPROJECT}
# Update the app by seting min-scale to the new value
ibmcloud ce app update --name ${CEAPP} --min-scale ${CEMINSCALE}
exit 0