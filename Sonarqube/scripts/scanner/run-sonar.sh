#!/bin/bash

set -e

[ -z "$PROJECT_ROOT" ] && echo "Please set PROJECT_ROOT env variable" && exit 1;
[ -z "$SONAR_URL" ] && echo "Please set SONAR_URL env variable" && exit 1;
[ -z "$SONAR_TOKEN" ] && echo "Please set SONAR_TOKEN env variable" && exit 1;
[ -z "$PROJECT_KEY" ] && echo "Please set PROJECT_KEY env variable" && exit 1;
[ -z "$PROJECT_NAME" ] && echo "Please set PROJECT_NAME env variable" && exit 1;
[ -z "$PROJECT_VERSION" ] && echo "Please set PROJECT_VERSION env variable" && exit 1;

if [[ "$OSTYPE" == "darwin"* ]]; then
    realpath() {
        [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
    }
fi

SCRIPT_PATH=$(dirname $(realpath "$0"))

docker run -it --rm \
    -v $(echo $PROJECT_ROOT)/:/app \
    -v "$SCRIPT_PATH/sonar-entrypoint.sh":/sonar-entrypoint.sh \
    --env="SONAR_BIN_DIR=" \
    --env="SONAR_URL=${SONAR_URL}" \
    --env="SONAR_TOKEN=${SONAR_TOKEN}" \
    --env="PROJECT_KEY=${PROJECT_KEY}" \
    --env="PROJECT_NAME=${PROJECT_NAME}" \
    --env="PROJECT_VERSION=${PROJECT_VERSION}" \
    --workdir=/app \
    --entrypoint=/sonar-entrypoint.sh \
    --add-host=tco-intcon-srv:10.132.200.130 \
    solutis/sonar-scanner
