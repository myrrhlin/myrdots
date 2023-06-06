# ~/.bash_logout: executed by bash(1) when login shell exits.

cd $HOME
if [ -f .dirsave ] ; then
  mv .dirsave .dirsave.old
fi
dirs -p >> .dirsave.old
sort -u .dirsave.old > .dirsave

# TODO history compactification
# uniq -c .bash_eternal_history   # remove duplicate lines
# remove 'd'

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
  # [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
