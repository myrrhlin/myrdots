# aliases are _not_ preserved in subshells

alias fig=docker-compose
alias grm='git fetch -p && git rebase --autostash origin/main'

alias qprove="$STARTERVIEW/bin/zr-push-branch-for-testing --nopush --branch"
alias gbranches=contrib/git/aeruder/git-branch-summary

alias zdb=$STARTERVIEW/bin/zr-mysql
alias zreply='reply -I$STARTERVIEW/app/lib -MStarterView::Bootstrap -MZR::Service::DBIC'

# Alternate between simdb and refdb (shared-reference-db)
alias set-refdb='ZR_APP_LIVE_CONFIG=/run/shm/www.starterview/live.json tsar-v -- $STARTERVIEW/bin/refdb on'
alias set-simdb='ZR_APP_LIVE_CONFIG=/run/shm/www.starterview/live.json tsar-v -- $STARTERVIEW/bin/refdb off'

alias aptup='sudo apt update && sudo apt upgrade'

alias zpanm='cpanm --cpanmetadb http://zpan-api.d1-dev-uw2.zipaws.com/v1 -M https://public-nosensitive-ziprecruiter-zpan.s3-us-west-2.amazonaws.com'
# -L /usr/local/zrperl/lib  put stuff in /usr/local/zrperl/lib/lib/perl5
# can add -S for sudo

alias zamu="$STARTERVIEW/bin/laptop/macos/zamu.scpt"

# source devxp_aliases

