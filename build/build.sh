#! /bin/sh

# Our helm charts have the version format 'x.y.z-a', where a is the number of commits since the last tagged version.
# A tagged version's 'a' will be 0.
# CHART_VER is the 'x.y.z' part of the version. Helm charts may not have a v in their versioning tag.
# CHART_REL is the 'a' part of the version.

CHART_VER=$(git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//')
if [ -n "${CHART_VER}" ]; then
    CHART_REL=$(git rev-list --count v${CHART_VER}..HEAD 2>/dev/null )
else
    CHART_REL=$(git rev-list --count HEAD 2>/dev/null )
fi

CHART_VER=${CHART_VER:-0.0.1} CHART_REL=${CHART_REL:-0} \
    envsubst < build/Chart.yaml.in > ${CHART_NAME}/Chart.yaml