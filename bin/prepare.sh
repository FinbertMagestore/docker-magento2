#!/usr/bin/env bash

source .env

# get version php from version magento
function get_version_php() {
    local php_version=""
    if [[ ${1} == 2.3* ]]; then
        php_version="7.2"
        if [[ ${INSTALL_PWA_STUDIO} = '1' ]]; then
            php_version="7.1"
        fi
    elif [[ ${1} == 2.2* ]]; then
        php_version="7.1"
    elif [[ ${1} == 2.1* ]]; then
        php_version="7.0"
    fi
    echo ${php_version}
}

function get_port_service_docker() {
    local port_service_docker=''
    local php_version=`get_version_php "${1}"`
    if [[ ! -z "${php_version}" ]]; then
        local port_service_docker="${1//./}""${php_version//./}"
        while [[ ${#port_service_docker} > 5 ]]; do
            port_service_docker="${port_service_docker::-1}"
        done
    fi
    echo ${port_service_docker}
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

# check environment for install pwa studio: SAMPLE_DATA=0, INSTALL_PWA_STUDIO=1 and $1 is version magento which must greater or equals 2.3.0
function check_install_pwa_studio() {
    local is_install_pwa_studio=0
    if [[ ${INSTALL_PWA_STUDIO} = '1' ]]; then
        if [[ ${SAMPLE_DATA} = '0' ]]; then
            local version_compare_result=`version_compare $1 '2.3.0' '<'`
            if [[ ${version_compare_result} = '0' ]]; then
                is_install_pwa_studio=1
            fi
        fi
    fi
    echo ${is_install_pwa_studio}
}

function prepare_environment_for_once_version_magento() {
    if [[ -f docker-compose.yml ]]; then
        local line_number_image_name_db=`awk '/# image_name_db/{ print NR; exit }' docker-compose.yml`
        if [[ ! -z ${line_number_image_name_db} ]]; then
            local is_install_pwa_studio=`check_install_pwa_studio ${MAGENTO_VERSION}`
            if [[ ${is_install_pwa_studio} = '1' ]]; then
                bash -c "sed -i '${line_number_image_name_db}s/.*/    image: ngovanhuy0241\/docker-magento-multiple-db:${MAGENTO_VERSION}-pwa # image_name_db/' docker-compose.yml"
            else
                bash -c "sed -i '${line_number_image_name_db}s/.*/    image: ngovanhuy0241\/docker-magento-multiple-db:${MAGENTO_VERSION} # image_name_db/' docker-compose.yml"
            fi
        fi
    fi

    if [[ -f .env ]]; then
        local line_number_name_db=`awk '/MYSQL_DATABASE/{ print NR; exit }' .env`
        local port_service_docker=`get_port_service_docker "${MAGENTO_VERSION}"`
        bash -c "sed -i '${line_number_name_db}s/.*/MYSQL_DATABASE=magento${port_service_docker}/' .env"
    fi
    
    if [[ -f 'magento/Dockerfile' ]]; then
        local line_number_image_name_magento=`awk '/FROM/{ print NR; exit }' .env`
        local php_version=`get_version_php "${MAGENTO_VERSION}"`
        bash -c "sed -i '${line_number_image_name_magento}s/.*/FROM ngovanhuy0241/docker-magento-multiple-magento:php${php_version//./}/' .env"
        
    fi
}

function main() {
    prepare_environment_for_once_version_magento
}

main