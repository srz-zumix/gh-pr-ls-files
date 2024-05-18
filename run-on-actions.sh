#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)

LS_FILES=$("${SCRIPT_DIR}/gh-pr-ls-files" "$@" | grep -E "${INPUTS_FILTER:-.*}")

if [ -z "${LS_FILES}" ]; then
    echo "files="  | tee -a "${GITHUB_OUTPUT:-/dev/null}"
    echo "count=0" | tee -a "${GITHUB_OUTPUT:-/dev/null}"
    exit 0
fi

FILE_LIST=(${LS_FILES})
FILE_COUNT=$(echo "${LS_FILES}" | wc -l | xargs -I{} echo {})
echo "count=${FILE_COUNT}" | tee -a "${GITHUB_OUTPUT:-/dev/null}"

if [ "${INPUTS_DELIMITER:-' '}" == $'\n' ]; then
    if [ "${FILE_COUNT}" -gt 1 ]; then
        DELIMITER="<$(openssl rand -hex 8)>"
        {
            echo "files<<${DELIMITER}"
            echo "${LS_FILES}"
            echo "${DELIMITER}"
        } | tee -a "${GITHUB_OUTPUT:-/dev/null}"
        exit 0
    fi
fi

IFS=${INPUTS_DELIMITER:-' '}
FILES=$(echo "${FILE_LIST[*]}")

echo "files=${FILES}" | tee -a "${GITHUB_OUTPUT:-/dev/null}"
