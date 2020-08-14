#!/bin/sh

GITHUB_WORK_DIR=/github/workspace
DEBUG=1

log_debug () {
    if [[ $DEBUG ]]; then
        echo " [DEBUG] $@"
    fi
}

log_info () {
    echo " [INFO] $@"
}

log_error () {
    echo " [ERROR] $1" 1>&2
    exit 1
}

dirpath="$1"
pds4_version="$2"
release="$3"
verbose="$4"

# Check valid dirpath is specified
if [ -z "$dirpath" ]; then
    log_error "Valid directory path must be specified (dirpath)."
fi

dirpath=$GITHUB_WORK_DIR/$dirpath
if  [ ! -d "$dirpath" ]; then
    log_error "Valid directory path must be specified. Dirpath: $dirpath"
fi

# Check dirpath contains schemas / schematrons / labels to validate
if ! ls $dirpath/*.xml 1> /dev/null 2>&1 ; then
    ls $dirpath/*.xml
    log_error "Invalid dirpath. Must contain at least one of schema, schematron, and XML label"
fi

if [ "$verbose" == "true" ]; then
    DEBUG=0
fi

validate_version=$(curl --silent "https://api.github.com/repos/NASA-PDS/validate/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' | sed 's/v//')
log_info "Validate version: $validate_version"

wget -q --directory-prefix=/tmp https://github.com/NASA-PDS/validate/releases/download/${validate_version}/validate-${validate_version}-bin.tar.gz
tar -xf /tmp/validate-${validate_version}-bin.tar.gz -C /tmp/

/tmp/validate-${validate_version}/bin/validate --skip-content-validation -R pds4.label -x $dirpath/*.xsd -S $dirpath/*.sch -t $dirpath/*.xml

exit $?