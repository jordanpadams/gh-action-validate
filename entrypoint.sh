#!/bin/sh

log_info () {
    echo " [INFO] $@"
}

log_error () {
    echo " [ERROR] $1" 1>&2
    exit 1
}

dirpath="$1"
schemas="$2"
schematrons="$3"
failure="$4"
verbose="$5"

# Check valid dirpath is specified
if [ -z "$dirpath" ]; then
    log_error "Valid directory path must be specified (dirpath)."
fi

if  [ ! -d "$dirpath" ]; then
    log_error "Valid directory path must be specified. Dirpath: $dirpath"
fi

# Check dirpath contains schemas / schematrons / labels to validate
if ! ls $dirpath/*.xml 1> /dev/null 2>&1 ; then
    log_error "Invalid dirpath. Must contain at least one of schema, schematron, and XML label"
fi

# Get latest validate version from Github
validate_version=$(curl --silent "https://api.github.com/repos/NASA-PDS/validate/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/v//')
log_info "Validate version: $validate_version"

# Download the latest version and unpack
wget -q --directory-prefix=/tmp https://github.com/NASA-PDS/validate/releases/download/${validate_version}/validate-${validate_version}-bin.tar.gz
tar -xf /tmp/validate-${validate_version}-bin.tar.gz -C /tmp/

# Validate the input data
args="--skip-content-validation -R pds4.label"
if [ -n "$schemas" ]; then
    args="$args -x $schemas"
fi

if [ -n "$schematrons" ]; then
    args="$args -S $schematrons"
fi
/tmp/validate-${validate_version}/bin/validate -t $dirpath/*.xml $args

exit $?