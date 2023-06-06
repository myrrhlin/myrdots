# commands to create tmux sessions

# use with:
# tmux source-file start.tmux

# cd ~/ziprecruiter
new-session -A -s devi -n shell -c ~/ziprecruiter $SHELL
# new-window -n test -t devi:1 mrsa partners/job_api --branch test
# www/starterview run shell --no-deps
new-window -n test -t devi:1 mrsa partners/job_api --branch shell
new-window -n edit -t devi:2 vim partners/job_api

detach-client

