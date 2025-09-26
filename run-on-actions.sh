#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd -P)

# Step 1: Get the list of files.
# If gh-pr-ls-files fails (e.g., from a timeout), `set -e` will cause the script to exit here.
LS_FILES=$("${SCRIPT_DIR}/gh-pr-ls-files" "$@")

# Step 2: Apply include filter.
# The `|| [[ $? == 1 ]]` construct ensures that the script doesn't fail if grep finds no matches (exit code 1),
# but it will fail on other grep errors (exit code > 1).
LS_FILES=$(echo "${LS_FILES}" | grep -E "${INPUTS_FILTER:-.*}" || [[ $? == 1 ]])

# Step 3: Apply exclude filter.
if [ -n "${INPUTS_EXCLUDE:-}" ]; then
    LS_FILES=$(echo "${LS_FILES}" | grep -vE "${INPUTS_EXCLUDE:-><}" || [[ $? == 1 ]])
fi

if [ -z "${LS_FILES}" ]; then
    echo "files="  | tee -a "${GITHUB_OUTPUT:-/dev/null}"
    echo "count=0" | tee -a "${GITHUB_OUTPUT:-/dev/null}"
    exit 0
fi

# shellcheck disable=SC2206
FILE_LIST=(${LS_FILES})
FILE_COUNT=$(echo "${LS_FILES}" | wc -l | xargs -I{} echo {})
echo "count=${FILE_COUNT}" | tee -a "${GITHUB_OUTPUT:-/dev/null}"

if [ -z "${INPUTS_DELIMITER:-}" ]; then
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
# shellcheck disable=SC2116
FILES=$(echo "${FILE_LIST[*]}")

echo "files=${FILES}" | tee -a "${GITHUB_OUTPUT:-/dev/null}"