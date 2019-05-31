#!/bin/bash

# get common settings
if [ ! -f "zshrc_common" ]; then
  echo -e "\nERROR: script files not found!\n"
  exit
fi
source "zshrc_common" 2>/dev/null

# sudo not allowed
if [ `whoami` = "root" ]; then
  echo -e "\nERROR: sudo not allowed!\n"
  exit
fi

# download resources.
print_title "DOWNLOAD RESOURCES..."

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

# repositories
print_title "ADDING REPOSITORIES..."
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# repository -> update
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get -y autoclean

# Install docker packages.
sudo apt-get -y install docker-ce
sudo apt-get -y install python3-pip
sudo apt-get -y install build-essential libssl-dev libffi-dev python3-dev

#sudo apt-get -y install code

# install php
sudo apt-get -y install php php-xml php-cgi php-cli php-common php-curl php-gd php-imap php-intl php-mysql php-json php-mcrypt php-xmlrpc php-dev php-recode php-tidy php-mbstring php-geoip php-imagick php-memcache php-memcached php-oauth php-xdebug php-apcu php-gettext

# install composer
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
sudo chown $USER:$CIT_DOMAIN_USERS -Rf $COMPOSER_DIR

# drush, php_codesniffer, drupalsecure_code_sniffs, codeception
print_title "Installing DRUSH, PHPCS, DRUPALCS..."
composer global require "drush/drush" "squizlabs/php_codesniffer" "drupal/coder"

# -> drush
sudo ln -sfn "$COMPOSER_DIR/vendor/bin/drush" "/usr/local/bin/drush"
drush -y dl "registry_rebuild"

# -> php_codesniffer
sudo ln -sfn "$COMPOSER_DIR/vendor/bin/phpcs" "/usr/local/bin/phpcs"

# -> drupalsecure_code_sniffs
sudo rm -rf $DRUPALSECURE_CS_DIR 2>/dev/null
git clone --branch master https://git.drupal.org/sandbox/coltrane/1921926.git $DRUPALSECURE_CS_DIR
ln -sfn $DRUPALSECURE_CS_DIR/secure_cs.drush.inc $CODER_SNIFFER_DIR/secure_cs.drush.inc
ln -sfn $DRUPALSECURE_CS_DIR/DrupalSecure $CODER_SNIFFER_DIR/DrupalSecure
$COMPOSER_DIR/vendor/bin/phpcs --config-set installed_paths $CODER_SNIFFER_DIR

# -> drupalsecure_code_sniffs -> apply path
ORIGINAL_FILE=$DRUPALSECURE_CS_DIR/DrupalSecure/Sniffs/General/HelperSniff.php
PATCH_FILE=$CONFIG_DIR/parenthesis_closer_notice-2320623-2.patch
patch --forward $ORIGINAL_FILE $PATCH_FILE
sudo chown $USER:$CIT_DOMAIN_USERS -Rf $COMPOSER_DIR

# install docker compose.
print_title "Installing DOCKER COMPOSE..."
chmod +x /usr/local/bin/docker-compose
mkdir -p ~/.zsh/completion && curl -L https://raw.githubusercontent.com/docker/compose/1.16.1/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose
echo "fpath=(~/.zsh/completion \$fpath)" >> $ZSHRC
echo "autoload -Uz compinit && compinit -i" >> $ZSHRC

# all done
print_done "\nAll Done, restart your system!"