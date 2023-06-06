# aliases are _not_ preserved in subshells

alias fig=docker-compose

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

alias zamu="$STARTERVIEW/bin/laptop/macos/zamu.scpt"

# aliases for switching between tiers in k8s. (make sure to make selection in ZAM as well.)
alias k8s-d='export KUBECONFIG=~/.kube/configs/d1-dev-uw2; echo $KUBECONFIG'
alias k8s-s='export KUBECONFIG=~/.kube/configs/s2-stg-ue1; echo $KUBECONFIG'
alias k8s-p='export KUBECONFIG=~/.kube/configs/p1-prod-ue1; echo $KUBECONFIG'

