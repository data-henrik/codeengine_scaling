#!/bin/bash

set -ex

# if CE_DATA is present, inject key/value pairs as env variables
# needed to pass in, e.g., CE_MIN_SCALE from cron event
if [ "$CE_DATA" ]; then
    for s in $(echo "${CE_DATA}" | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" ); do
        export $s
    done
fi

# IBM Cloud login and data upload to COS
ibmcloud login  -g ${IC_RESOURCE_GROUP} -r ${IC_REGION}
ibmcloud ce project select --name ${CE_PROJECT}
ibmcloud ce app update --name ${CE_APP} --min-scale ${CE_MIN_SCALE}
exit 0
