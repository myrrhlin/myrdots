# reminders so i don't have to look it up again.
# subshells keep: exported vars and function, cwd, file mode mask, open files
# bash startup files: for --login
# 1) /etc/profile
# 2) first: ~/.bash_profile ~/.bash_login ~/.profile
# otherwise, interactive but not login:
# ~/.bashrc

# https://docs.brew.sh/Homebrew-and-Python

# /usr/local/etc/bash_completion.d
#asdf.bash		brew			git-prompt.sh
#aws_bash_completer	git-completion.bash	tig-completion.bash
source /usr/local/etc/bash_completion.d/git-completion.bash
source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/etc/bash_completion.d/tig-completion.bash

# requires git-prompt.sh above
PROMPT_COMMAND='__git_ps1 "[\u@\h \W]" "\\\$ "'

function set_tab_title() {
  printf '\e]1;%s\a' "$*"
}

# find dotf directory, relative to this file
function _dotf_dir {
  local here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  if [ -d "$here/dotf" ] ; then
    DOTF="$here/dotf"
    echo $DOTF
  else
    false;
  fi
}

fn_exists() {
  # not all bashes have -t option for type builtin
  # LC_ALL=C type -t $1 | grep -q 'function'
  local thingy=$(LC_ALL=C type -t $1)
  test function = "$thingy"
}

DOTF=$(_dotf_dir)
if [ -n "$DOTF"  ] ; then 
  export DOTF
  if fn_exists "...sourceif" ; then
    ...sourceif "$DOTF/dirstack.sh"
    # ehistory alters PROMPT_COMMAND
    ...sourceif "$DOTF/ehistory.bash"
    ...sourceif "$DOTF/gitlib.sh"
  fi
fi

[ -f /usr/local/opt/asdf/libexec/asdf.sh ] && source /usr/local/opt/asdf/libexec/asdf.sh  

# let curl use current certs from https://curl.se/docs/caextract.html
# https://blog.bytesguy.com/resolving-lets-encrypt-issues-with-curl-on-macos
# curl -k https://curl.se/ca/cacert.pem -o ~/.cacert.pem
test -f "$HOME/.cacert.pem" && export CURL_CA_BUNDLE=~/.cacert.pem

# add ZR for local perl? this should come before perlbrew...
export ZR_REPO="$HOME/ziprecruiter"
if [ $SHLVL -eq 1 ] ; then
  export PERL5LIB=$(printf "$ZR_REPO/app/lib"; printf ":%s" $ZR_REPO/common/perl/*/lib)
  # setup perl local lib:
  eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"
fi

# install perlbrew
test -f "$HOME/perl5/perlbrew/etc/bashrc" && source ~/perl5/perlbrew/etc/bashrc

export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=1
# export GIT_PS1_SHOWSTASHSTATE=1
export EDITOR=vim

export STARTERVIEW="$ZR_REPO"
export PATH="~/go/bin:$ZR_REPO/bin:$ZR_REPO/infrastructure/terraform/bin:$PATH"
export ECR_URL="734371315114.dkr.ecr.us-west-2.amazonaws.com"

[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# https://stackoverflow.com/questions/18880024/start-ssh-agent-on-login

SSH_ENV="$HOME/.ssh/env"

function start_agent {
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
          start_agent;
        }
     else
       echo "SSH_ENV file was empty. source it later:"
       echo "  source $SSH_ENV"
     fi
     # flock -u "$SSH_ENV"
  else
    start_agent;
  fi
}

# Source SSH settings, if applicable

#randomize execution time, so only one process writes the ENV file
perl -MTime::HiRes=sleep -e'sleep rand(3)'
if [ -f "${SSH_ENV}" ]; then
   . "${SSH_ENV}" > /dev/null
   if [ -n "$SSH_AGENT_PID" ]; then
      #ps ${SSH_AGENT_PID} doesn't work under cywgin
      ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        echo existing SSH_ENV file was stale -- starting new
        start_agent;
      }
   else
      echo "SSH_ENV file was empty. source it later:"
      echo "  source $SSH_ENV"
   fi
else
    start_agent;
fi

