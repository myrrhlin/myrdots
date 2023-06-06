#! /bin/bash

# a library of useful bash functions for interacting with git
# mhamlin
# last revised 140922

# "bash strict mode" http://redsymbol.net/articles/unofficial-bash-strict-mode/
# not useful in interactive shell
# set -euo pipefail
# IFS=$'\n\t'

function gitlib_synopsis() {
cat << EOD
 $ branch_exists foo && echo "yes"
 $ branch_exists master && echo "yes"
 yes
 $ repo_exists && echo "on branch \$(current_branch)"
 on branch handle-features
 $ echo "HEAD is \$(current_sha1) with message '\$(current_commit_msg)', \$(commits_ahead) commits ahead of origin"
 HEAD is b52b71d with message 'WiP-handle-features', 3 commits ahead of origin
 $ commits_ahead
 3
 $ unstaged_changes_exist && git commit -a -m WiP
 [handle-features 4697e96] WiP
 1 files changed, 18 insertions(+), 3 deletions(-)

 $ branch_exists handle-features && gco handle-features
No unsaved changes.
Switched to branch 'handle-features'
Your branch is ahead of 'origin/handle-features' by 3 commits.
Unstaged changes after reset:
M	t/lib/LW/Billing/Master/Test.pm

EOD
}

# TODO: all functions need to deal well with floating head
# TODO: all functions should check for repo first

E_NOREPO=250     # no git repo detected in path
E_CONFLICT=251   # a merge/rebase/cherry-pick conflict was encounted, requires a human

E_BADARGS=253   # bad arguments to a function
E_ABORT=254     # action refused, consequences uncertain
E_INSANE=255    # a sanity check failed

# ================================================================
# boolean functions, can be evaluated directly for truth aka success(0)

REMOTE=${GITREMOTE:-origin}

# returns true (0) if a repo contains current path
function repo_exists() {
	# &> redirects both stdout and stderr
	git status -s &> /dev/null
}
# returns true (0) if modified files have been staged (git add) but not committed
function staged_changes_exist() {
    git status -s | grep -qc '^M '
}
# returns true (0) if modified files that have not been staged (git add)
function unstaged_changes_exist() {
    git status -s | grep -qc '^ M'
}
# returns true (0) if a given branch name exists, false(1) otherwise
function branch_exists() {
    [ -z "$1" ] && return $E_BADARGS
    # multiple matches prevented by anchoring both ends
    # exit status of grep is success (0) if lines found
    git branch --no-color 2> /dev/null | grep -qc "^[ *] $1$"
}
function branch_exists_remote() {
    local branch="$1"
    [ -z "$branch" ] && branch=$(current_branch)
    git branch -r --no-color 2> /dev/null | grep -qc "^  $REMOTE/$branch$"
}

# ================================================================
# informational functions, outputting a piece of data, capture with $()

# outputs the current branch name... what happens in floating HEAD?
function current_branch() {
    # git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
    # git branch --no-color 2> /dev/null | sed -n 's/^\* //p'
    git rev-parse --abbrev-ref HEAD
}
# e.g. "origin/master"
function remote_branch() {
    # TODO -- use a given branch,
    # then use this in "branch_exists_remote"
    git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null
}
# outputs the sha1 of the current HEAD
function current_sha1() {
    # git log -n1 --oneline --no-color | cut -d' ' -f1
    git rev-parse --short HEAD
}
# outputs the msg of the current HEAD's commit message
function current_commit_msg() {
    # git log -n1 --oneline --no-color | cut -d' ' --complement -f1
    git log -1 --pretty=%s
}
# outputs the sha1 of the current remote HEAD
function current_sha1_remote() {
    local branch="$1"
    [ -z "$branch" ] && branch=$(current_branch)
    [ -z "$branch" ] && return $E_BADARGS
	if ! branch_exists_remote "$branch"
	then echo "No remote branch $branch exists."
		return $E_ABORT
	fi
    git log $REMOTE/$branch -n1 --oneline --no-color | cut -d' ' -f1
}
# outputs the number of commits ahead of origin the current branch is
function commits_ahead() {
    local branch="$1"
    local remotebranch="$2"
    [ -z "$branch" ] && branch=$(current_branch)
    [ -z "$branch" ] && return $E_BADARGS
    if [ -z "$remotebranch" ]
    then remotebranch=$(remote_branch)
    fi
	if ! branch_exists_remote "$branch"
	then echo "No remote branch $branch exists."
		return $E_ABORT
	fi
    git log --oneline --first-parent $REMOTE/$branch.. | wc -l
}

# ================================================================
# action functions, performing a specific task

function gsuspend() {
	if unstaged_changes_exist || staged_changes_exist
	then echo Saving uncommitted work as WiP commit.
		git commit -a -m WiP-$(current_branch)
	else echo No unsaved changes.
	fi
}
# unconditionally reset last commit, keeping its code (unstaged)
# TODO: do not reset if last commit already pushed to origin
function gpop() {
	# git reset --soft HEAD^ && git reset
	git reset HEAD^
}
function gresume() {
	if [[ $(current_commit_msg) == WiP* ]]
	then gpop
	else echo Current HEAD is not WiP -- use gpop to uncommit it anyway
	fi
}
function greb() {
    local base="$1"
    if [ -n "$base" ] && ! branch_exists "$base"
    then echo Branch "$base" does not exist
    elif ! branch_exists_remote
    then  # never pushed to origin... can't know what it was based off
        echo Branch is local only.  No remote branch to rebase upon.
    else
        base="$REMOTE/$(current_branch)"
    fi
    if [ -n "$base" ] ; then
	   gsuspend
	   git rebase -i "$base"
    fi
}

# needs git-bash-completion...
function gco() {
	# doesnt deal well with floating HEAD.
	local branch="$1"
	[ -z "$branch" ] && return $E_BADARGS
	branch_exists "$branch" || return $E_BADARGS
	# short-circuit a no-op:
	[ "$branch" = $(current_branch) ] && return 0
	gsuspend
	git checkout "$branch"
	if [[ $(current_commit_msg) == WiP* ]]
	then echo "Resuming previous work (resetting WiP commit)"
		gresume
	fi
}

# resets branch back $1 commits (keeping the code, not the commits)
# aborts if that reset would cross a merge
function soft_reset_n() {
    local npop="$1"
    [ -z "$npop" ] && npop=0
    [ "$npop" -eq 0 ] && return $E_BADARGS
    if ! git log --oneline --first-parent --merges HEAD~$npop.. | wc -l 1> /dev/null
    then echo "found a merge, cannot reset past that"
        # unsure code can reliably find correct parent when resetting
        return $E_ABORT
    fi
    git reset --soft HEAD~$npop && git reset
}
function hard_reset_n {
    local npop="$1"
    [ -z "$npop" ] && npop=0
    [ "$npop" -eq 0 ] && return $E_BADARGS
    if ! git log --oneline --first-parent --merges HEAD~$npop.. | wc -l 1> /dev/null
    then echo "found a merge, cannot reset past that"
        # unsure code can reliably find correct parent when resetting
        return $E_ABORT
    fi
    git reset --hard HEAD~$npop
}

# show commits in git branch that aren't in your current branch
function gbin {
    local current_branch=$(current_branch)
    echo branch \($1\) has these commits and \($current_branch\) does not
    git log ..$1 --no-merges --format='%h | %an | %ad | %s' --date=local
}

# show commits in your current branch that aren't in a specified branch
function gbout {
	local dbranch="$1"
	branch_exists $dbranch || return $E_BADARGS
    echo branch \($(current_branch)\) has these commits and \($dbranch\) does not
    git log $dbranch.. --no-merges --format='%h | %an | %ad | %s' --date=local
}

# resolve a rebase conflict by taking all the new branch code
function gtakemine {
    # https://stackoverflow.com/questions/24743769/git-resolve-conflict-using-ours-theirs-for-all-files
    git diff --name-only --diff-filter=U | xargs git checkout --theirs
}

# --fork-point not supported until 1.9
function forkpoint() {
    local branch="$1"
    [ -z "$branch" ] && branch=$(current_branch)
	git merge-base --fork-point origin/master $branch
}
