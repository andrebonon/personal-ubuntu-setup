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

# check arguments
case $1 in
  install) ;;

  version) echo -e "\n${GREEN}ubuntu_env ${WHITE}version ${YELLOW}$VERSION${NORMAL}\n"
    exit ;;

  *) clear
  echo -e "
    ${YELLOW}Usage:
      ${WHITE}bash ubuntu_env.sh [options]

    ${YELLOW}Options:
      ${GREEN}install     ${WHITE}install environment
      ${GREEN}version     ${WHITE}show script version
      ${GREEN}help        ${WHITE}show this display

    ${YELLOW}REQUIREMENTS (for \"installation ubuntu environment\")

    ${YELLOW}$VERSION${NORMAL}\n"
    exit ;;
esac

# prepare environment
print_title "Preparing ENVIRONMENT..."
mkdir -p $OH_DIR
mkdir -p $DB_DIR
mkdir -p $DOWNLOADS_DIR
mkdir -p $PROGRAMS_DIR
mkdir -p $PROJECTS_DIR
mkdir -p $REPO_DIR
mkdir -p $USER_CONFIG_DIR
mkdir -p "$HOME/.local/share/applications" && chmod 700 "$HOME/.local/share/applications"
rsync -av . "$OH_DIR/"
rm -f "$HOME/.local/share/keyrings/login.keyring" 2>/dev/null
touch $ZSHRC_USER

# repository
print_title "Installing REPOSITORY..."

# repository -> java
sudo add-apt-repository ppa:webupd8team/java

# repository -> atom
sudo add-apt-repository -y ppa:webupd8team/atom

# repository -> php5.6
sudo LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php

# repository -> nodejs
wget -q -O - https://deb.nodesource.com/setup_6.x | sudo -E bash -

# repository -> chrome and chromium
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main | sudo tee /etc/apt/sources.list.d/google-chrome.list

# repository -> virtualbox
wget -q -O - https://www.virtualbox.org/download/oracle_vbox.asc | sudo apt-key add -
echo deb http://download.virtualbox.org/virtualbox/debian trusty contrib | sudo tee /etc/apt/sources.list.d/virtualbox.list

# repository -> spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

# repository -> skype
sudo sh -c 'echo "deb http://archive.canonical.com/ubuntu trusty partner" >> /etc/apt/sources.list.d/canonical_partner.list'

# repository -> update
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get -y autoclean

# packages
print_title "Installing PACKAGES..."
sudo apt-get -y install oracle-java8-installer
sudo apt-get -y install pepperflashplugin-nonfree
sudo apt-get -y install xterm
sudo apt-get -y install virtualbox-5.0
sudo apt-get -y install aria2
sudo apt-get -y install pv
sudo apt-get -y install vim
sudo apt-get -y install xclip
sudo apt-get -y install terminator
sudo apt-get -y install htop
sudo apt-get -y install meld
sudo apt-get -y install shutter
sudo apt-get -y install spotify-client
sudo apt-get -y install ttf-mscorefonts-installer
sudo apt-get -y install xfonts-100dpi
sudo apt-get -y install xfonts-75dpi
sudo apt-get -y install xfonts-scalable
sudo apt-get -y install xfonts-cyrillic
sudo apt-get -y install build-essential
sudo apt-get -y install python-software-properties
sudo apt-get -y install mcrypt
sudo apt-get -y install imagemagick
sudo apt-get -y install memcached
sudo apt-get -y install curl
sudo apt-get -y install mysql-workbench
sudo apt-get -y install mysql-server
sudo apt-get -y install mysql-client
sudo apt-get -y install php5.6
sudo apt-get -y install php5.6-xml
sudo apt-get -y install php5.6-cgi
sudo apt-get -y install php5.6-cli
sudo apt-get -y install php5.6-common
sudo apt-get -y install php5.6-curl
sudo apt-get -y install php5.6-gd
sudo apt-get -y install php5.6-imap
sudo apt-get -y install php5.6-intl
sudo apt-get -y install php5.6-mysql
sudo apt-get -y install php5.6-json
sudo apt-get -y install php5.6-mcrypt
sudo apt-get -y install php5.6-xmlrpc
sudo apt-get -y install php5.6-dev
sudo apt-get -y install php5.6-recode
sudo apt-get -y install php5.6-tidy
sudo apt-get -y install php5.6-mbstring
sudo apt-get -y install php5.6-geoip
sudo apt-get -y install php5.6-imagick
sudo apt-get -y install php5.6-memcache
sudo apt-get -y install php5.6-memcached
sudo apt-get -y install php5.6-oauth
sudo apt-get -y install php5.6-xdebug
sudo apt-get -y install php5.6-apcu
sudo apt-get -y install php-gettext
sudo apt-get -y install apache2
sudo apt-get -y install apache2-doc
sudo apt-get -y install apache2-utils
sudo apt-get -y install libapache2-mod-php5.6
sudo apt-get -y install libapache2-mod-fcgid
sudo apt-get -y install libapache2-mod-python
sudo apt-get -y install phpmyadmin
sudo apt-get -y install git
sudo apt-get -y install zsh
sudo apt-get -y install nodejs
sudo apt-get -y install skype

# mysql
print_title "Installing MYSQL..."
sudo rsync -av "/etc/mysql/my.cnf" "/etc/mysql/my.cnf.bak"
sudo sed 's/key_buffer/key_buffer_size/g' /etc/mysql/my.cnf
sudo sed 's/myisam-recover/myisam-recover-options/g' /etc/mysql/my.cnf

# php5.6
print_title "Installing PHP5.6..."
sudo ln -sfn /usr/bin/php5.6 /etc/alternatives/php
sudo ln -sfn /usr/share/man/man1/php5.6.1.gz /etc/alternatives/php.1.gz
sudo pear channel-update pear.php.net
sudo php5enmod mcrypt

# composer
print_title "Installing COMPOSER..."
cd "$DOWNLOADS_DIR"
wget -Nc https://getcomposer.org/installer
php installer
sudo mv composer.phar "/usr/local/bin/composer"
sudo chown root:root "/usr/local/bin/composer"

# apache
sudo ln -s  /home/$USER/Projects /var/www/sites
sudo mv "/etc/apache2/apache2.conf" "/etc/apache2/apache2.conf.bak"
sudo rsync -av "$CONFIG_DIR/apache2.conf" "/etc/apache2/apache2.conf"
sudo rsync -av "$CONFIG_DIR/001-custom.conf" "/etc/apache2/sites-available/001-custom.conf"
sudo a2enmod rewrite
sudo a2ensite 000-default.conf
sudo a2ensite 001-custom.conf

# create "localhost/info.php"
echo '<?php phpinfo();' | sudo tee '/var/www/html/info.php'
echo '<?php phpinfo();' | sudo tee '/var/www/sites/info.php'

# oh-my-zsh
print_title "Installing OH-MY-ZSH..."
chsh -s $(which zsh)
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="fox"/g' $ZSHRC
sed -i "\:source $ZSHRC_COMMON:d" $ZSHRC
sed -i "\:source $ZSHRC_USER:d" $ZSHRC
echo "source $ZSHRC_COMMON" >> $ZSHRC
echo "source $ZSHRC_USER" >> $ZSHRC

# drush, php_codesniffer, drupalsecure_code_sniffs, codeception
print_title "Installing DRUSH, PHPCS, DRUPALCS, CODECEPTION..."
sudo chown $USER:$USER -Rf $COMPOSER_DIR
composer global require "drush/drush:7.*" "squizlabs/php_codesniffer" "drupal/coder" "codeception/codeception"

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
sudo chown $USER:$USER -Rf $COMPOSER_DIR

# -> codeception
sudo ln -sfn "$COMPOSER_DIR/vendor/bin/codecept" "/usr/local/bin/codecept"

# grunt, browser-sync, npm-check, tldr
print_title "Installing GRUNT, BROWSER-SYNC, NPM-CHECK, TLDR..."
sudo npm -g install grunt-cli \
browser-sync \
npm-check \
--ignore-scripts tldr
sudo tldr --update

# setting gitconfig
print_title "Setting GITCONFIG..."
read -p "${YELLOW}Enter your full name: ${NORMAL}" FULL_NAME
read -p "${YELLOW}Enter your email: ${NORMAL}" EMAIL
echo -e "${NORMAL}"

# generation ssh key
ssh-keygen -t rsa -b 4096 -C "$EMAIL"

# setting gitconfig
git config --global credential.helper cache
git config --global user.name "$FULL_NAME"
git config --global core.fileMode false
git config --global user.email "$EMAIL"
git config --global push.default simple
git config --global core.excludesfile $HOME/.gitignore_global
git config --global diff.tool meld
git config --global diff.guitool meld
git config --global difftool.prompt false
git config --global merge.tool meld
git config --global merge.conflictstyle diff3
git config --global mergetool.keepBackup false

# configure hosts
sudo rsync -av "/etc/hosts" "/etc/hosts.bak"
sudo sed -i s/'127.0.0.1\tlocalhost'/'127.0.0.1\tsites.localhost'/ "/etc/hosts"

# configure php5.6
sudo sed -i s/'memory_limit = 128M'/'memory_limit = 1024M'/ "/etc/php/5.6/apache2/php.ini"
sudo sed -i s/'error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT'/'error_reporting = E_ALL'/ "/etc/php/5.6/apache2/php.ini"
sudo sed -i s/'display_errors = Off'/'display_errors = On'/ "/etc/php/5.6/apache2/php.ini"

# configure grunt
npm install grunt --save-dev
npm install grunt-contrib-less --save-dev
npm install grunt-contrib-cssmin --save-dev
npm install grunt-contrib-watch --save-dev

# restart apache
sudo service apache2 restart

# all done
print_done "\nAll Done, restart your system!"
