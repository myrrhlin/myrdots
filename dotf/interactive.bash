
source $DOTF/dirstack.sh
source $DOTF/gitlib.sh

export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=1
# export GIT_PS1_SHOWSTASHSTATE=1
export EDITOR=vim

PROMPT_COMMAND='__git_ps1 "[\u@\h \W]" "\\\$ "'

source $DOTF/ehistory.bash

function lt {
  ls -lt "$@" | head
}
function modvers {
  local modname="$@"
  perl -M"$modname" -E"say \$$modname::VERSION"
}
function authors {
  git annotate --line-porcelain "$@" | grep "^author " | sort | uniq -c | sort -nrk 1
}


export PERLDOC_PAGER='less -r'

source $DOTF/zip-env.bash

ZPAN_URL=http://zpan-api.b1-build-uw2.zipaws.com/v1
function zpani {
  for modname in "$@" ; do
    curl -s $ZPAN_URL/history/$modname | perl -pe 's/ {8,}/    /g'
  done
}
