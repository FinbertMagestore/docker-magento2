# Docker compose for Magento 2.

## Build Docker Magento 2
1. Download Magento
    - Copy src magento to folder `src/magento2.tar.gz`.
    - Download magento by command line
        - Edit magento version and magento sample data version in file `.env`
            ```text
            MAGENTO_VERSION=2.2.6
            SAMPLE_DATA=1 # install magento with sample data
            MAGENTO_EDITION=CE # install magento edition is CE/EE
            ```
            ```bash
            ./bin/downloadMagento.sh
            ```
2. Build images
    ```bash
    ./bin/build.sh
    ```
3. Run service
    ```bash
    ./bin/run.sh #Run containers, show output to console
    ./bin/run.sh -d #Run containers in the background, print new container names
    ```
4. Provide permission edit for user `www-data` to in docker container folder `/var/www/html`
    ```bash
    ./bin/ssh.sh root
    ```
    ```bash
    chown -R www-data:www-data ./
    chmod -R 777 ./
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
./bin/ssh.sh user
```

### Note
- Docker: Apache2, Php7.1 Magento2, MariaDb, Phpmyadmin, Composer
    - Magento run at port: http - 9090 and https: 9092
- Install nginx in host (nginx reverse proxy)
- Links:
    - Magento2: 
        - Frontend: https://magento2.com/
        - Backend: https://magento2.com/admin/
        
            Username: admin
            
            Password: admin123
    - Phpmyadmin: http://phpmyadmin.magento2.com/
- Source:
    - Download Magento 2: http://pubfiles.nexcess.net/magento/ce-packages/
    