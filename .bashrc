
export MY_SANDBOX="sandbox-$USER-01.legacy-dev-uw2.zipaws.com"
export SHARED_SANDBOX="shared-sandbox-01.legacy-dev-uw2.zipaws.com"

export INSTANCE="https://www-$USER-01.legacy-dev-uw2.zipaws.com"
export ADMINSTANCE="https://admin-$USER-01.legacy-dev-uw2.zipaws.com"

export PGUSER=michaelh
export PGPORT=5439
# export PGDATABASE=prod

alias go-my-sandbox="ssh $MY_SANDBOX"
alias go-shared-sandbox="ssh $SHARED_SANDBOX"

alias go-app="open $INSTANCE"
alias go-admin="open $ADMINSTANCE"

# https://docs.brew.sh/Homebrew-and-Python

