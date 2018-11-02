#!/bin/bash
source "$APACHE_ENVVARS"
tar xvf magento2.tar.gz
chown -R $APACHE_RUN_USER:$APACHE_RUN_USER ./
chmod -R 777 ./
# Install magento
php bin/magento setup:install --use-rewrites=1 \
    --db-host=db \
    --db-name=magento \
    --db-password=magento \
    --db-prefix=m_ \
    --admin-firstname=admin \
    --admin-lastname=admin \
    --admin-email=admin@localhost.com \
    --admin-user=admin \
    --admin-password=admin123 \
    --base-url=$BASE_URL \
    --backend-frontname=admin \
    --admin-use-security-key=0 \
    --key=8f1e9249ca82c072122ae8d08bc0b0cf

# Update config for testing
php bin/magento config:set cms/wysiwyg/enabled disabled
php bin/magento config:set admin/security/admin_account_sharing 1
php bin/magento config:set admin/captcha/enable 0

php bin/magento deploy:mode:set developer
php bin/magento setup:static-content:deploy -f