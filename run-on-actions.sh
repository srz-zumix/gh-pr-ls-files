#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)

LS_FILES=$(${SCRIPT_DIR}/gh-pr-ls-files "$@")

if [ -z "${LS_FILES}" ]; then
    echo "files=" | tee -a "${GITHUB_OUTPUT:-/dev/null}"
    echo "count=0" | tee -a "${GITHUB_OUTPUT:-/dev/null}"
else
    FILE_COUNT=$(echo "${LS_FILES}" | wc -l | xargs -I{} echo {})
    if [ "${FILE_COUNT}" -gt 1 ]; then
        DELIMITER="<$(openssl rand -hex 8)>"
        {
        echo "files<<${DELIMITER}"
        echo "${LS_FILES}"
        echo "${DELIMITER}"
        } | tee -a "${GITHUB_OUTPUT:-/dev/null}"
    else
        echo "files=${LS_FILES}" | tee -a "${GITHUB_OUTPUT:-/dev/null}"
    fi
    echo "count=${FILE_COUNT}" | tee -a "${GITHUB_OUTPUT:-/dev/null}"
fi
