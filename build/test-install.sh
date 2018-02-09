#!/usr/bin/env bash
#
# This script installs the helm chart and tests
# against the deployed helm release. This script
# assumes helm is properly installed.

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

# install
helm install --replace --name ${RELEASE} --namespace ${NAMESPACE} ./${CHART_NAME}

# wait for full es cluster to come up
echo Waiting for install 
sleep 120

# if there are tests, run them against the installed chart
if [[ -d ${CHART_NAME}/templates/tests ]]; then
  echo Testing release ${RELEASE}
  helm test ${RELEASE} --cleanup
  HELM_TEST_EXIT_CODE=$?
fi

exit ${HELM_TEST_EXIT_CODE}
