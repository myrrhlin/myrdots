# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate 
#.bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
# if [ -z "$HISTFILE" ] ; then
if [ "$HISTFILE" == ~/.bash_history ] ; then
  HISTFILE=~/.bash_eternal_history
fi
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
