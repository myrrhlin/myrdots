# commands to create tmux sessions

# use with:
# tmux source-file start.tmux

# cd ~/ziprecruiter
new-session -A -s devi -n shell -c ~/ziprecruiter $SHELL
# new-window -n test -t devi:1 mrsa partners/job_api --branch test
# www/starterview run shell --no-deps
#new-window -n test -t devi:1 mrsa partners/job_api --branch shell
#new-window -n edit -t devi:2 vim partners/job_api

new-window -n edit -t devi:1 -c ~/zr/partner/signals_api vim -p app/public/draft.yaml app/lib/Signals/API.pm
# vim -S apply-url.vim  # restore saved vim session

detach-client

