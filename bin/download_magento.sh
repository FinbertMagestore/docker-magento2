#!/usr/bin/env bash

source .env

if [[ ! ${MAGENTO_EDITION} = 'CE' ]]; then
    exit
fi

MAGENTO_DOWNLOAD_URL='http://pubfiles.nexcess.net/magento/ce-packages/magento2-'${MAGENTO_VERSION}'.tar.gz'
MAGENTO_FILENAME='magento/magento2-'${MAGENTO_VERSION}'.tar.gz'

if [[ ${SAMPLE_DATA} = '1' ]]; then
    MAGENTO_DOWNLOAD_URL='http://pubfiles.nexcess.net/magento/ce-packages/magento2-with-samples-'${MAGENTO_VERSION}'.tar.gz'
    MAGENTO_FILENAME='magento/magento2-with-samples-'${MAGENTO_VERSION}'.tar.gz'
fi

if [[ ! -f  ${MAGENTO_FILENAME} ]]; then
    wget -O ${MAGENTO_FILENAME} ${MAGENTO_DOWNLOAD_URL}
fi