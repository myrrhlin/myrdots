
export ZR_REPO=/var/starterview
export PERL5LIB=$ZR_REPO/$APP/app/lib:$PERL5LIB

# assume dotf dir is where we are...
export DOTF="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if [ -f /cargo/appbase_history ] ; then
  # use bash history file in mounted (synced) directory
  HISTFILE=/cargo/appbase_history
  history -r
fi

if [ -f "$DOTF/ehistory.bash" ] ; then
  # save history after every command, unlimited size
  source $DOTF/ehistory.bash
  export HISTCONTROL=erasedups:ignorespace
fi

source "$DOTF/dirstack.sh"

