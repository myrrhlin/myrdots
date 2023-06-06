# code modified from
# http://aijazansari.com/2010/02/20/navigating-the-directory-stack-in-bash/index.html

# An enhanced 'cd' - push directories onto a stack as you navigate to it.
# The current directory is at the top of the stack.

function stack_cd {
    local target="$1"
    if [ -z "$target" ] ; then
        # the normal cd behavior is to enter $HOME if no
        # arguments are specified
        target="$HOME"
    elif [ ! -d "$target" ] ; then
        echo no directory "$target"
        target=
    fi
    if [ -n "$target" ] ; then
        # use the pushd bash command to push the directory
        # to the top of the stack, and enter that directory
        pushd "$target" > /dev/null
    fi
}
alias cd=stack_cd

# Swap the top two directories on the stack

function swap_stack_top {
    pushd > /dev/null
}
alias s=swap_stack_top

# Pop the top (current) directory off the stack and move to the next

function pop_stack {
    popd > /dev/null
}
alias p=pop_stack

# Display the stack of directories and prompt the user for an entry.
#    'p'  = pop the stack
#    's'  = swap the current and previous
#  integer = move to selected one
#  other   = nothing

function choose_dir {
    local dir="$1"
    if [ -z "$dir" ] ; then
        dirs -v
        echo -n "p,s,q,#: "
        read dir
    fi
    if [ -z "$dir" ] ; then
        dir=0
    fi
    if [[ $dir = 'p' ]]; then
        pop_stack
    elif [ "s" = "$dir" ]; then
        swap_stack_top
    elif (( "$dir" > 0 )); then
        local d=$(dirs -l +$dir);
        popd +$dir > /dev/null
        pushd "$d" > /dev/null
    fi
}
alias d=choose_dir

