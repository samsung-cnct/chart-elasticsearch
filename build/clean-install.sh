#!/usr/bin/env bash
#
# This script un-installs the helm chart and 
# manually removes PVCs

set -o errexit
set -o nounset
set -o pipefail

CHART_NAME=${CHART_NAME:?CHART_NAME must be set}
NAMESPACE=${NAMESPACE:?NAMESPACE must be set}
RELEASE=${RELEASE:?RELEASE must be set}

if [[ ! -d ${CHART_NAME} ]]; then
  echo >&2 "Directory for chart '$CHART_NAME' does not exist."
  exit 1
fi

# cleanup
echo Cleaning up
helm delete --purge ${RELEASE} &> /dev/null &

echo Waiting for un-install
sleep 600

# Note: This assumes the default storage class has been
# created with a reclaimPolicy of Delete. Otherwise the
# PVs will need to be manually deleted.
echo Deleting associated PVCs
kubectl delete pvc -l app=elasticsearch -n  ${NAMESPACE}
