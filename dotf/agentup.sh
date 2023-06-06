# this must be sourced -- cannot be run in subshell

# https://stackoverflow.com/questions/18880024/start-ssh-agent-on-login

SSH_ENV="$HOME/.ssh/env"

function _start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded.  now:
    chmod 600 "${SSH_ENV}"
    source "${SSH_ENV}" > /dev/null
    # this requires entering a password...
    echo /usr/bin/ssh-add "~/.ssh/zipid"
}

function _ensure_agent {
  if [ -f "$SSH_ENV" ]; then
     # env file exists, try to lock it
     #unset foo
     #exec {foo}<> "$SSH_ENV"
     #flock -n $foo
     source "$SSH_ENV" > /dev/null
     if [ -n "$SSH_AGENT_PID" ]; then
        #ps ${SSH_AGENT_PID} doesn't work under cywgin
        ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
          echo existing SSH_ENV file was stale -- starting new
          # rm "$SSH_ENV"
          _start_agent
        }
     else
       echo "SSH_ENV file was empty. source it later:"
       echo "  source $SSH_ENV"
     fi
     # flock -u "$SSH_ENV"
  else
    _start_agent
  fi
}

function randsleep {
  local delay=3
  perl -MTime::HiRes=sleep -e"sleep rand($delay)"
}

#randomize execution time, so only one process writes the ENV file
randsleep
_ensure_agent

