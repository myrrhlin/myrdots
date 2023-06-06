# zip-specific for interactive bash environment

export STARTERVIEW=$HOME/ziprecruiter
export ZR_APP_LIVE_CONFIG=/run/shm/www.starterview/live.json
export PATH=$PATH:$STARTERVIEW/infrastructure/terraform/bin

if [ $SHLVL -eq 1 ] ; then
  echo skipping mucking with PERL vars
  #export PERL5LIB=$(printf "$STARTERVIEW/app/lib"; printf ":%s" $STARTERVIEW/common/perl/*/lib)
  #eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"
fi

# [ $SHLVL -eq 1 ] && eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"

# for bin/zr-push-branch-for-testing
export BUILDBOT_SLACK='@michaelh'

# prove saves all tap output somehwere...
export PERL_TEST_HARNESS_DUMP_TAP=$HOME/var/log/tap
# export ZR_LOG_LEVEL=warn
export ZR_LOG_FORMAT=plain
export MRSA_LESS_CHATTER=1

pushd $STARTERVIEW/app/lib/ZR/JobResponse/DeliveryAgent > /dev/null
# pushd $STARTERVIEW/app/t/tests/TestsFor/ZR/JobResponse/DeliveryAgent > /dev/null
pushd -0 > /dev/null
pushd $HOME/ziprecruiter > /dev/null

# prune tags on mondays -- now a crontab
# if [[ $(date +%u) == 1 ]] ; then git fetch --prune --prune-tags; fi

# defines tsh function for starting perl testing container
# tsh_no_auto_fresh=1
tsh_config=contrib/bin/michaelh/tsh
source $STARTERVIEW/contrib/bin/jober/perl-testing/setup.sh

