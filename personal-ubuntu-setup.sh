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
      ${WHITE}bash personal_ubuntu_env.sh [options]

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

#repository
#print_title "Installing REPOSITORY..."

# repository -> macbuntu
#sudo add-apt-repository ppa:noobslab/macbuntu

# repository -> java
sudo add-apt-repository ppa:webupd8team/java

# repository -> nodejs
#wget -q -O - https://deb.nodesource.com/setup_6.x | sudo -E bash -

# repository -> chrome and chromium
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main | sudo tee /etc/apt/sources.list.d/google-chrome.list

# repository -> virtualbox
#wget -q -O - https://www.virtualbox.org/download/oracle_vbox.asc | sudo apt-key add -
#echo deb http://download.virtualbox.org/virtualbox/debian trusty contrib | sudo tee /etc/apt/sources.list.d/virtualbox.list

# repository -> spotify
#sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 0DF731E45CE24F27EEEB1450EFDC8610341D9410
#echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

# repository -> update
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get -y autoclean

# mac ubuntu theme packages
#print_title "Installing MAC Ubuntu Theme..."
#sudo apt-get -y install unity-tweak-tool
#sudo apt-get -y install gnome-tweak-tool
# docky
#sudo apt-get -y install plank
# theme
#sudo apt-get -y install macbuntu-os-icons-lts-v7
#sudo apt-get -y install macbuntu-os-ithemes-lts-v7
#sudo apt-get -y install macbuntu-os-plank-theme-lts-v7
# albert
#sudo apt-get -y install albert


# program packages
print_title "Installing PROGRAM PACKAGES FROM SNAP..."
sudo snap install spotify
sudo snap install postman
sudo snap install gimp
sudo snap install slack --classic

print_title "Installing PROGRAM PACKAGES..."
sudo apt-get -y install oracle-java8-installer
sudo apt-get -y install pv
sudo apt-get -y install vim
sudo apt-get -y install xclip
sudo apt-get -y install terminator
sudo apt-get -y install htop
sudo apt-get -y install lnav
sudo apt-get -y install meld
sudo apt-get -y install ttf-mscorefonts-installer
sudo apt-get -y install xfonts-100dpi
sudo apt-get -y install xfonts-75dpi
sudo apt-get -y install xfonts-scalable
sudo apt-get -y install xfonts-cyrillic
sudo apt-get -y install fonts-noto
sudo apt-get -y install fonts-roboto
sudo apt-get -y install build-essential
sudo apt-get -y install python-software-properties
sudo apt-get -y install curl
sudo apt-get -y install git
sudo apt-get -y install zsh
sudo apt-get -y install ubuntu-restricted-extras

# oh-my-zsh
print_title "Installing OH-MY-ZSH..."
chsh -s $(which zsh)
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sed -i "\:source $ZSHRC_COMMON:d" $ZSHRC
sed -i "\:source $ZSHRC_USER:d" $ZSHRC
echo "source $ZSHRC_COMMON" >> $ZSHRC
echo "source $ZSHRC_USER" >> $ZSHRC

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

# all done
print_done "\nAll Done, restart your system!"
