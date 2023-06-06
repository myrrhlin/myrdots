#echo ingesting .bashrc
# echo shell options are $-
# himBH (ssh) or hBc (scp)

source ~/bashrc.orig

export DOTF=~/dotf

if [[ $- == *i* ]] ; then
  source $DOTF/interactive.bash
fi
  
