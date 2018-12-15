#!/usr/bin/env bash

source .env

# get version php from version magento
function get_version_php() {
    PHP_VERSION=""
    if [[ ${1} == 2.3* ]]; then
        PHP_VERSION="7.2"
    elif [[ ${1} == 2.2* ]]; then
        PHP_VERSION="7.1"
    elif [[ ${1} == 2.1* ]]; then
        PHP_VERSION="7.0"
    elif [[ ${1} == 1.* ]]; then
        PHP_VERSION="5.6"
    fi
    echo ${PHP_VERSION}
}

function get_version_magento() {
    MAGENTO_VERSION=''
    if [[ ${1} == 2.* ]]; then
        MAGENTO_VERSION=2
    elif [[ ${1} == 1.* ]]; then
        MAGENTO_VERSION=1
    fi
    echo ${MAGENTO_VERSION}
}

function version_lib() {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

# compare version: $1 and $2 with operator $3
# echo 1 if version $1 operator $3 with version $2 else echo 0.
# example: version_compare '1.9.4' '1.9.3' '>' => echo 1
function version_compare() {
    version_lib $1 $2
    case $? in
        0) op='=';;
        1) op='>';;
        2) op='<';;
    esac
    if [[ ${op} != $3 ]]
    then
        echo 0
    else
        echo 1
    fi
}

# get port of service docker.
# if port >= 6 character, remove last character
# ex: version magento is 2.2.6 => port: 22671; 2.1.15 => port: 21157
function get_port_service_docker() {
    PORT_SERVICE_DOCKER=''
    local PHP_VERSION=`get_version_php "${1}"`
    if [[ ! -z "${PHP_VERSION}" ]]; then
        PORT_SERVICE_DOCKER="${1//./}""${PHP_VERSION//./}"
        while [[ ${#PORT_SERVICE_DOCKER} > 5 ]]; do
            PORT_SERVICE_DOCKER="${PORT_SERVICE_DOCKER::-1}"
        done
    fi
    echo ${PORT_SERVICE_DOCKER}
}

# get port ssl of service docker.
# if port >= 5 character, remove last character. Then add '0' to end of string
# ex: version magento is 2.2.6 => port: 22670; 2.1.15 => port: 21150
function get_port_ssl_service_docker() {
    PORT_SERVICE_DOCKER=''
    local PHP_VERSION=`get_version_php "${1}"`
    if [[ ! -z "${PHP_VERSION}" ]]; then
        PORT_SERVICE_DOCKER="${1//./}""${PHP_VERSION//./}"
        while [[ ${#PORT_SERVICE_DOCKER} > 4 ]]; do
            PORT_SERVICE_DOCKER="${PORT_SERVICE_DOCKER::-1}"
        done
    fi
    PORT_SERVICE_DOCKER=${PORT_SERVICE_DOCKER}'0'
    echo ${PORT_SERVICE_DOCKER}
}

# print status
function print_status() {
    echo "## $1"
}

# print Done
function print_done() {
    echo "Done."
}

# quit process
function bail() {
    echo 'Error executing command, exiting'
    exit 1
}

# exec cmd, if error still continuous process
function exec_cmd_nobail() {
    echo "+ $1"
    bash -c "$1"
}

# exec cmd, if error quit process
function exec_cmd() {
    exec_cmd_nobail "$1" || bail
}

function curl_check () {
  print_status "Checking for curl..."
  if command -v curl > /dev/null; then
    print_status "Detected curl..."
  else
    print_status "Installing curl..."
    sudo apt-get install -q -y curl
    if [ "$?" -ne "0" ]; then
      echo "Unable to install curl! Your base system has a problem; please check your default OS's package repositories because curl should work."
      echo "Repository installation aborted."
      exit 1
    fi
  fi
}

function calculate_time_run_command() {
    start=$(date +%s)
    $1
    end=$(date +%s)
    diff=$(( $end - $start ))
    print_status "+ ${1}: It took $diff seconds"
}

function exit_print_error() {
    echo $1
    exit
}
