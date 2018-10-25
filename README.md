# Docker compose for Magento 2.

## Use batch script
### Build images
```bash
./bin/build.sh
```

### Run service
```bash
./bin/run.sh
```

### Install magento 2
```bash
./bin/ssh.sh
./install_magento.sh
```

### Stop service
```bash
./bin/stop.sh
```

### Remove service
```bash
./bin/remove.sh
```

### SSH
```bash
./bin/ssh.sh
```

### Note
- Had installed: Apache2, Php7.1 Magento2, MariaDb, Phpmyadmin, Composer
- Links:
    + Magento2: 
        + Fontend: https://magento2.com/
        + Backend: https://magento2.com/admin/
        
            Username: admin
            
            Password: admin123
    + Phpmyadmin: http://magento2.com:9091/
- Note:
    - SSH to docker as root, provide permission for folder `/var/www/`
        ```bash
        sudo chown -R www-data:www-data /var/www
        ```