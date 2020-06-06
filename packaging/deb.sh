#!/usr/bin/env bash

# Prereq: apt-get install dh-make devscripts

set -e
set -x

# Configure your paths and filenames
SCRIPTS=(
    ../gam
)
NAME=gam
VERSION=1.1

# Create your scripts source dir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
FOLDER="${DIR%/*}/dist"
FOLDER="${FOLDER}/${NAME}-${VERSION}"
mkdir -p "${FOLDER}"

# Copy your script to the source dir
for S in ${SCRIPTS[@]}; do
    cp "${DIR}/${S}" "${FOLDER}"
done
cd "${FOLDER}"

# Create the packaging skeleton (debian/*)
#dh_make -s --indep --createorig 
dh_make --indep --createorig 

# Remove make calls
grep -v makefile debian/rules > debian/rules.new 
mv debian/rules.new debian/rules 

# debian/install must contain the list of scripts to install 
# as well as the target directory
rm -f debian/install
for S in ${SCRIPTS[@]}; do
    echo ${S##*/} usr/bin >> debian/install
done

# Remove the example files
rm debian/*.ex

# Build the package.
# You  will get a lot of warnings and ../somescripts_0.1-1_i386.deb
debuild