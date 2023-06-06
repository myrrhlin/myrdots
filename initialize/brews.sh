#! /usr/bin/env bash

# brews

# bash strict mode
set -euo pipefail

if ! which brew >/dev/null ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
fi

function installed() {
  local package="$1"
  brew list "$package" 2>/dev/null | wc -l >/dev/null
}

function maybe_install() {
  local package="$1"
  if installed $package ; then
    # maybe upgrade?
    brew info "$package" | head -1
  else
    # echo Brewing $package ...
    brew install "$package"
  fi
}

# IFS should include whitespace
while IFS="\n" read -u10 -r package || [ -n "$package" ]
do
  maybe_install $package
done 10<<EOLIST
git
bash
jq
the_silver_searcher
fzf
fd
tig
mc
bash
tmux
python@3.9
awscli
syncthing
mysql-client
stern
mkcert
nss
EOLIST

# python is required by awscli
# mkcert required to make local cert authority and cert for dev work
# https://dev.to/aschmelyun/using-the-magic-of-mkcert-to-enable-valid-https-on-local-dev-sites-3a3c
# nss for firefox

# possibly add tmate and pgcli

# add new  bash to permitted shells list
brewbash=/usr/local/bin/bash
if grep $brewbash /etc/shells >/dev/null ; then
  # if [ $(grep bash /etc/shells | wc -l) -eq 1 ] ; then
  echo homebrew bash is permitted login shell
else
  echo admin required to add updated bash to permitted shells:
  echo sudo -e /etc/shells
  echo $brewbash
  # sudo cat <<EOD >>/etc/shells
  # /usr/local/bin/bash
  # EOD
fi

# set default shell to new bash..
if grep $brewbash /etc/shells >/dev/null ; then
  #UserShell: /bin/bash
  current=$( dscl . -read ~/ UserShell | awk '{print $2}')
  if [ "$current" = "/bin/bash" ] ; then 
    echo password required to change default shell
    chsh -s $brewbash
    echo default shell changed!
  fi
fi

# two options for installing terraform
function terraform1() {
  # deprecated.  use bin/terraform
  maybe_install asdf
  asdf plugin-add terraform
  asdf install terraform 0.11.14
  asdf global terraform 0.11.14
}

function terraform2() {
  # deprecated.  use bin/terraform
  maybe_install 'terraform@0.11'
  brew link --force 'terraform@0.11'
  brew pin 'terraform@0.11'
}

 
