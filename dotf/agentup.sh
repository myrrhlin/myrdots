# inspired by
# https://stackoverflow.com/questions/18880024/start-ssh-agent-on-login

SSH_ENV="$HOME/.ssh/env"

function _init_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    # this requires entering a password...
    echo /usr/bin/ssh-add "$HOME/.ssh/zipid"
}

function ensure_agent {
  if [ -f "$SSH_ENV" ]; then
     # env file exists, try to lock it
     #unset foo
     #exec {foo}<> "$SSH_ENV"
     #flock -n $foo
     . "$SSH_ENV" > /dev/null
     if [ -n "$SSH_AGENT_PID" ]; then
        #ps ${SSH_AGENT_PID} doesn't work under cywgin
        ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
          # file was stale (no such agent running)
          rm "$SSH_ENV"
          _init_agent;
        }
     else
       echo "SSH_ENV file was empty. source it later:"
       echo "  source $SSH_ENV"
     fi
     # flock -u "$SSH_ENV"
  else
    _init_agent;
  fi
}

function start_agent {
	if [ -f "${SSH_ENV}" ]; then
	   . "${SSH_ENV}" > /dev/null
	   if [ -n "$SSH_AGENT_PID" ]; then
	      #ps ${SSH_AGENT_PID} doesn't work under cywgin
	      ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
		echo existing SSH_ENV file was stale -- starting new
		_init_agent;
	      }
	   else
	      echo "SSH_ENV file was empty. source it later:"
	      echo "  source $SSH_ENV"
	   fi
	else
	    _init_agent;
	fi
}

# Source SSH settings, if applicable

#randomize execution time, so only one process writes the ENV file
perl -MTime::HiRes=sleep -e'sleep rand(3)'
start_agent;

