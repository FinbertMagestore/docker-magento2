# Docker for Magento
Docker image for Magento.

## Use batch script
### Build images
```bash
bin/build
```

### Run service
```bash
bin/run
```

### Stop service
```bash
bin/stop
```

### SSH
```bash
bin/ssh
```

## Use docker command line
### Build images
```bash
sudo docker-compose build
```

### Run service
```bash
sudo docker-compose up -d
```

### Stop service
```bash
sudo docker-compose down
```

### SSH
```bash
sudo docker exec -u {username} -it {container_name} /bin/bash
```