# Eternal bash history.
# ---------------------
# source this file, interactive shells only

if [ -z "${PS1:-}" ] ; then
	# return works from sourced script
	return;
fi

#echo HISTFILE=${HISTFILE:-empty}
#echo HISTSIZE=${HISTSIZE:-empty}
#echo HISTFILESIZE=${HISTFILESIZE:-empty}

# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "

# Change the file location because certain bash sessions truncate
#.bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
# set HISTFILE if unset, empty, or the default location:
if [ "${HISTFILE:=$HOME/.bash_eternal_history}" == ~/.bash_history ] ; then
	HISTFILE=~/.bash_eternal_history
fi
export HISTFILE

# TODO rotate history file is too large (so appending to it remains fast)

# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
# PROMPT_COMMAND array only supported from version 5.1alpha
# TODO check bash version and use array if supported!
if [ -z "${PROMPT_COMMAND:-}" ] ; then
	# it was unset or empty;
	PROMPT_COMMAND="history -a"
elif [[ "$(declare -p PROMPT_COMMAND)" =~ "^declare -a" ]] ; then
	# it was an array, so just preprend to it
	PROMPT_COMMAND=( "history -a" "${PROMPT_COMMAND[@]}" )
else
	# it was set and non-empty, but not an array
	# but because older bash doesnt support it, we'll emulate
	# TODO: check if command has already been added?
	PROMPT_COMMAND="history -a;${PROMPT_COMMAND-}"
fi

# function for development testing...
__exec_prompt_commands () {
	local exit=$?
	# since 4.4 localizing shell options possible:?
	local -
	set -euo pipefail
	for cmd in "$PROMPT_COMMANDS[@]" ; do
		eval "$cmd"
	done
	return $exit
}

