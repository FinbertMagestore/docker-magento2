#!/bin/bash
source "$APACHE_ENVVARS"
tar xvf magento2.tar.gz
chown -R $APACHE_RUN_USER:$APACHE_RUN_USER ./
chmod -R 777 ./
# Install magento
MAGENTO_CMD='php bin/magento setup:install --use-rewrites=1 '
MAGENTO_CMD+='--db-host=db '
MAGENTO_CMD+='--db-name=magento '
MAGENTO_CMD+='--db-password=magento '
MAGENTO_CMD+='--db-prefix=m_ '
MAGENTO_CMD+="--admin-firstname=admin "
MAGENTO_CMD+="--admin-lastname=admin "
MAGENTO_CMD+="--admin-email=admin@localhost.com "
MAGENTO_CMD+="--admin-user=admin "
MAGENTO_CMD+="--admin-password=admin123 "
MAGENTO_CMD+="--base-url=$BASE_URL "
MAGENTO_CMD+="--backend-frontname=admin "
MAGENTO_CMD+="--admin-use-security-key=0 "
MAGENTO_CMD+="--key=8f1e9249ca82c072122ae8d08bc0b0cf "
su "$APACHE_RUN_USER" -s /bin/bash -c "$MAGENTO_CMD"

# Update config for testing
MAGENTO_CMD='php bin/magento config:set cms/wysiwyg/enabled disabled '
MAGENTO_CMD+='&& php bin/magento config:set admin/security/admin_account_sharing 1 '
MAGENTO_CMD+='&& php bin/magento config:set admin/captcha/enable 0 '
su "$APACHE_RUN_USER" -s /bin/bash -c "$MAGENTO_CMD"

MAGENTO_CMD="php bin/magento deploy:mode:set developer"
MAGENTO_CMD+='&& php bin/magento setup:static-content:deploy -f'
su "$APACHE_RUN_USER" -s /bin/bash -c "$MAGENTO_CMD"