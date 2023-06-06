#! /bin/bash

function helpout {
cat <<EOD
gpush - push (some, not all) commits to origin
  $ gpush.sh <n>
pushes <n> new commits from your current branch to origin.  tries to be as cautious as
possible:
 - pulls from origin first, with rebase if necessary, aborts if rebase causes conflict
 - fails if you have fewer than <n> commits past origin
 - restores your branch after the push, regardless of success
EOD
        exit 0
}

npush="$1"
[ -z "$npush" ] && helpout
if [ "$npush" -eq 0 ]
then echo "Must give a positive integer, how many commits should be pushed"
        helpout
fi

source $DOTF/gitlib.sh

E_MERGERESET=5  # attempt to push commits prior to a merge


if ! repo_exists
then echo No repository found
        exit $E_NOREPO
fi

# current branch name
BRANCH="$(current_branch)"
[ -z "$BRANCH" ] && exit $E_NOREPO

# commit current work, if necessary
if unstaged_changes_exist || staged_changes_exist
then echo "committing oustanding changes..."
        git commit -a -m WiP-$BRANCH
fi

# this will fail if staged files haven't been committed
if ! git pull --rebase  >/dev/null
then echo "pull --rebase failed, aborting..."
        git rebase --abort
        exit $E_CONFLICT
fi

REMOTEBRANCH=$(remote_branch)
nahead=$(commits_ahead $BRANCH)
if [ "$nahead" -eq "0" ]
then echo "You are in sync with $REMOTEBRANCH.  Nothing to push."
        exit 0
fi
echo "You are $nahead commits ahead of $REMOTEBRANCH"
if [ "$nahead" -lt "$npush" ]
then echo "You do not have $npush commits to push."
        exit 0
fi

npop=$(expr $nahead - $npush)
ohead=$(current_sha1)
[ -z "$ohead" ] && exit $E_INSANE
echo "Popping off $npop commits from your HEAD ($ohead)"

if branch_exists "temp-$BRANCH"
then echo "temporary branch temp-$BRANCH exists, attempting to delete"
        exit 3
        # git branch -d temp-$BRANCH
        if ! [ $? ]
        then echo "couldnt remove branch"
                exit 3
        fi
fi

echo "return to head with: git reset --hard $ohead"
# save our current head before mucking with it:
# git branch temp-$BRANCH
# echo "                 or: git reset --hard temp-$BRANCH"

if soft_reset_n $npop >/dev/null
then echo "pop $npop successful, now pushing"
        git push $REMOTE HEAD
else echo Soft reset failed
fi

# return to original HEAD
# git reset --hard temp-$BRANCH
git reset --hard $ohead


