#! /bin/bash

# repos

# urls can have different forms:
# git@github.com:ingydotnet/....git (ssh form)
# git://github.com/ingydotnet/....git
# https://github.com/ingydotnet/....git

# ingydotnet/....git
function reponame() {
  local url="$1"
  echo "$url" | awk -F: '{print $NF}' | awk -F\/ '{print $(NF-1)"/"$NF}'
}

# ...
function repodir() {
  local url="$1"
  echo "$url" | awk -F\/ '{print $NF}' | sed "s/\.git$//"
}

function reposrc() {
  local url="$1"
  local dir=$(repodir "$url")
  if [ -d "$dir" ] ;  then
    git -C "$dir" remote get-url origin 2>/dev/null
  fi
}

function repoinstalled() {
  local url="$1"
  local dir=$(repodir "$url")
  if [ ! -d "$dir" ] ; then
    # echo target directory "$dir" does not exist
    false
    return
  fi
  local name1=$(reponame "$url")
  # echo reponame $url is $name1
  local origin=$(reposrc "$dir")
  if [ -z "$origin" ] ; then
    false
    return
  fi
  local name2=$(reponame "$origin")
  # echo reponame $origin is $name2
  test "$name1" = "$name2"
}

function maybe_install() {
  local package="$1"
  if repoinstalled $package ; then
    # maybe upgrade?
    echo repo $package appears to be installed
    return
  fi
  local dir=$(repodir "$package")
  if [ -d "$dir" ] ; then
    if (( $(ls -1 "$dir" 2>/dev/null | wc -l) > 0 )); then
      echo existing directory is non-empty, refusing to clone
      return
    fi
  fi
  echo Cloning $package
  git clone "$package"
}

# bash strict mode
set -euo pipefail

cd $HOME
maybe_install https://github.com/ingydotnet/....git

cd .../src
# maybe_install 

# testing
# echo https://github.com/ingydotnet/....git
# repodir https://github.com/ingydotnet/....git
# git clone https://github.com/ingydotnet/....git
# repoinstalled https://github.com/ingydotnet/....git || echo '... is not installed'

while IFS="\n" read -u10 -r package || [ -n "$package" ]
do
  echo maybe_install $package
done 10<<EOLIST
nothing
EOLIST

#git@github.com:ingydotnet/....git
#git://github.com/ingydotnet/....git

 
