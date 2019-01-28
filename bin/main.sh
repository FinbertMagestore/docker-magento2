#!/usr/bin/env bash

source .env

function calculate_time_run_command() {
    local start=$(date +%s)
    $1
    local end=$(date +%s)
    local diff=$(( $end - $start ))
    echo "+ ${1}: It took $diff seconds"
}

function print_site_magento() {
    print_status "Site magento:"
    echo
    echo "Magento version ${MAGENTO_VERSION}"
    echo "Frontend: https://magento2.com/"
    echo "Backend: https://magento2.com/admin"
    echo
    local ipAddress=`hostname -I | cut -f1 -d' '`
    echo "Database: http://${ipAddress}:9091"
    echo "Database name: ${MYSQL_DATABASE}"
}


function main() {
    source bin/download_magento.sh
    source bin/build.sh
    source bin/run.sh
    print_site_magento
}

calculate_time_run_command main