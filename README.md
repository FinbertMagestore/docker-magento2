# Docker compose for Magento 2.

## Build Docker Magento 2
1. Build images
    ```bash
    ./bin/build.sh
    ```
2. Copy src magento to folder `src/magento2.tar.gz`. Edit file `env` with version magento default is `2.2.6`
3. Run service
    ```bash
    ./bin/run.sh -d #Run containers in the background, print new container names
    ./bin/run.sh #Run containers, show output to console
    ```
4. Provide permission edit for user `www-data` to in docker container folder `/var/www/html`
    ```bash
    ./bin/ssh.sh root
    chown www-data:www-data ./
    ```
5. Install magento 2
    ```bash
    ./bin/ssh.sh
    ./install_magento.sh 
    ```

## Stop service
```bash
./bin/stop.sh
```

## Remove service
```bash
./bin/remove.sh
```

## SSH
SSH to docker container with user: `root` or `www-data`. Default is `www-data`
```bash
./bin/ssh.sh <user>
```

### Note
- Docker: Apache2, Php7.1 Magento2, MariaDb, Phpmyadmin, Composer
    - Magento run at port: http - 9090 and https: 9092
- Install nginx in host (nginx reverse proxy)
- Links:
    + Magento2: 
        + Fontend: https://magento2.com/
        + Backend: https://magento2.com/admin/
        
            Username: admin
            
            Password: admin123
    + Phpmyadmin: http://phpmyadmin.magento2.com/
- Note:
    - SSH to docker as root, provide permission for folder `/var/www/`
        ```bash
        sudo chown -R www-data:www-data /var/www
        ```