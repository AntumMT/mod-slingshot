#!/bin/bash

DOCS="$(dirname $(readlink -f $0))"
ROOT="$(dirname ${DOCS})"

CONFIG="${DOCS}/config.ld"

cd "${ROOT}"
# Clean old files
rm -rf "${DOCS}/reference"
# Create new files
ldoc -c "${CONFIG}" -d "${DOCS}/reference" ./
