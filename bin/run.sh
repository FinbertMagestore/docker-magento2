#!/usr/bin/env bash

function wait_for_db_start_done() {
    docker_container_name_db='docker-magento2_db_1'
    exec_cmd "until docker exec -it ${docker_container_name_db} bash -c 'mysql --user=root --password=${MYSQL_ROOT_PASSWORD} --execute \"SHOW DATABASES;\"' > /dev/null 2>&1; do sleep 2; done"
}

function install_magento() {
    local docker_container_name="docker-magento2_magento_1"
    docker exec -u www-data ${docker_container_name} bash -c "./install_magento.sh"
}

function add_host_to_local() {
    print_status "Add host to local..."
    exec_cmd "grep -q -F '127.0.0.1 m2.io' /etc/hosts || echo '127.0.0.1 m2.io' | sudo tee --append /etc/hosts > /dev/null"
    print_done
}

function main() {
    docker-compose up -d
    wait_for_db_start_done
}

calculate_time_run_command main