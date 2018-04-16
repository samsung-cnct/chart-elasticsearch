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
EXIT_CODE=0
ATTEMPT=0
TRY_THRESH=3

is_success()
{
  local count

  count=$(helm ls -a "$RELEASE" | wc -l)

  [[ $count -gt 0 ]] && return 1
  return 0
}

if [[ ! -d ${CHART_NAME} ]]; then
  echo >&2 "Directory for chart '$CHART_NAME' does not exist."
  exit 8
fi

# cleanup
echo Cleaning up
echo Waiting for un-install

# See CO-217 - helm delete/purge usually fails on the first
# attempt.
helm delete --purge "${RELEASE}" &> /dev/null &

if ! wait; then
  while ! is_success; do
    ((ATTEMPT++))

    [[ $ATTEMPT -ge $TRY_THRESH ]] && \
      {
        echo >&2 "helm was not able to delete/purge existing release: $RELEASE after $ATTEMPT tries."
        break
      }

    helm delete --purge "${RELEASE}" &> /dev/null &
    wait

    # shellcheck disable=SC2181
    [[ $? -gt 0 ]] && EXIT_CODE=$?

    echo >&2 "helm was unable to delete/purge $RELEASE on attempt $ATTEMPT"
  done
else
  if is_success; then
    echo 'helm delete/purge appears to have succeeded'
  else
    echo >&2 'helm delete/purge appears to have FAILED'
  fi
fi

# Note: This assumes the default storage class has been
# created with a reclaimPolicy of Delete. Otherwise the
# PVs will need to be manually deleted.
echo Deleting associated PVCs
kubectl delete pvc -l app=elasticsearch -n "${NAMESPACE}"

# persist the exit code from `helm delete` if it was > 0
[[ $EXIT_CODE ]] && exit $EXIT_CODE
exit 0
