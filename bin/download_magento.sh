#!/usr/bin/env bash

source bin/common.sh

if [[ ! ${MAGENTO_EDITION} = 'CE' ]]; then
    exit
fi

function download_magento2() {
    local magento_download_url='http://pubfiles.nexcess.net/magento/ce-packages/magento2-'${1}'.tar.gz'
    if [[ ${SAMPLE_DATA} = '1' ]]; then
        magento_download_url='http://pubfiles.nexcess.net/magento/ce-packages/magento2-with-samples-'${1}'.tar.gz'
    fi

    local magento_filename='magento/magento2-'${1}'.tar.gz'
    if [[ ! -f  ${magento_filename} ]]; then
        wget -O ${magento_filename} ${magento_download_url}
    fi
}

function main() {
    download_magento2 ${MAGENTO_VERSION}
}

calculate_time_run_command main