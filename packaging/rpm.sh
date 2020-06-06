#!/usr/bin/env bash

# Prereq: yum install rpm-build

set -e
#set -x

SCRIPTS=(
    ../gam
)
NAME=gam
VERSION=1.1

# Put SPEC in place
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
FOLDER="${DIR%/*}/dist/rpm"
mkdir -p "${FOLDER}/SPECS"
cp "${DIR}/spec" "${FOLDER}/SPECS/${NAME}-${VERSION}.spec"

# Make scripts folder
SCRIPT_FOLDER="${FOLDER}/SOURCES/${NAME}-${VERSION}/scripts"
mkdir -p "${SCRIPT_FOLDER}"

# Copy your script to the source dir
for S in ${SCRIPTS[@]}; do
    cp "${DIR}/${S}" "${SCRIPT_FOLDER}"
done

# Create the tar.gz
cd "${FOLDER}/SOURCES/"
tar -czf ${NAME}-${VERSION}.tar.gz ${NAME}-${VERSION}
cd -

# Build the package
echo "%_topdir ${FOLDER}" > ~/.rpmmacros
rpmbuild -vv --bb "${FOLDER}/SPECS/${NAME}-${VERSION}.spec"
