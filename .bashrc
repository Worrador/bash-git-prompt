alias gp='git push'
alias gc='git commit -v'
alias gcm='git commit -m "'
alias grm='git rebase origin/master'
alias gl='git log'
alias gca='git commit --amend'
alias gpf='git push --force'
alias grd='git rebase origin=develop'
alias gd='git diff'
alias gs='git status'
alias ga='git add .'
alias ll='ls -la'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias vdc='cd /c/repos/vdc_software'

# Create an alias to call the function
alias repos='jump_to_repo'

PROMPT_DIRTRIM=2
# Set config variables first
GIT_PROMPT_ONLY_IN_REPO=1

GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status
GIT_PROMPT_IGNORE_SUBMODULES=1 # uncomment to avoid searching for changed files in submodules
GIT_PROMPT_WITH_VIRTUAL_ENV=0 # uncomment to avoid setting virtual environment infos for node/python/conda environments
# GIT_PROMPT_VIRTUAL_ENV_AFTER_PROMPT=1 # uncomment to place virtual environment infos between prompt and git status (instead of left to the prompt)

# GIT_PROMPT_SHOW_UPSTREAM=1 # uncomment to show upstream tracking branch
# GIT_PROMPT_SHOW_UNTRACKED_FILES=normal # can be no, normal or all; determines counting of untracked files

GIT_PROMPT_SHOW_CHANGED_FILES_COUNT=1 # uncomment to avoid printing the number of changed files

# GIT_PROMPT_STATUS_COMMAND=gitstatus_pre-1.7.10.sh # uncomment to support Git older than 1.7.10

GIT_PROMPT_START='\[\e[33m\]$(basename $(git rev-parse --show-toplevel))/$(git rev-parse --show-prefix)\e[m'
# '\[\e[33m\]\w\[\e[m\]'    # uncomment for custom prompt start sequence
string="your_string_here/"
string="${string%/}"
GIT_PROMPT_END=' $ '      # uncomment for custom prompt end sequence

# as last entry source the gitprompt script
# GIT_PROMPT_THEME=Custom # use custom theme specified in file GIT_PROMPT_THEME_FILE (default ~/.git-prompt-colors.sh)
# GIT_PROMPT_THEME_FILE=~/.git-prompt-colors.sh
# GIT_PROMPT_THEME=Solarized # use theme optimized for solarized color scheme

GIT_PROMPT_START_ROOT="$(dirname "$PWD")"
GIT_PROMPT_SHOW_UNTRACKED_FILES=no
GIT_PROMPT_LEADING_SPACE=0

# Only source gitprompt.sh if we are in a git repository
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    source "$GIT_PROMPT_START_ROOT/bash-git-prompt/gitprompt.sh"
fi
