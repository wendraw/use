ZSH="$HOME/.oh-my-zsh"

eval "$(/opt/homebrew/bin/brew shellenv)"

# git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
# ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
ZSH_THEME="spaceship"

# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-z
)

# https://ohmyz.sh/
source $ZSH/oh-my-zsh.sh

# -------------------------------- #
# Node Package Manager
# -------------------------------- #
# https://github.com/antfu/ni

alias nio="ni --prefer-offline"
alias s="nr start"
alias d="nr dev"
alias b="nr build"
alias bw="nr build --watch"
alias t="nr test"
alias tu="nr test -u"
alias tw="nr test --watch"
alias w="nr watch"
alias p="nr play"
alias c="nr typecheck"
alias lint="nr lint"
alias lintf="nr lint --fix"
alias release="nr release"
alias re="nr release"

# -------------------------------- #
# Python
# -------------------------------- #
alias pip="pip3"

# -------------------------------- #
# Git
# -------------------------------- #

# Use github/hub
alias git=hub

# Go to project root
alias grt='cd "$(git rev-parse --show-toplevel)"'

alias gs='git status'
alias gp='git push'
alias gpf='git push --force'
alias gpft='git push --follow-tags'
alias gpl='git pull --rebase'
alias gcl='git clone'
alias gst='git stash'
alias gstmp='git stash -m "temp"'
alias gstp='git stash pop'
alias gstl='git stash list'
alias grm='git rm'
alias gmv='git mv'

alias main='git checkout main'

alias gco='git checkout'
alias gcob='git checkout -b'

alias gb='git branch'
alias gbd='git branch -d'

alias grb='git rebase'
alias grbom='git rebase origin/master'
alias grbc='git rebase --continue'

alias gl='git log'
alias glo='git log --oneline --graph'

alias grh='git reset HEAD'
alias grh1='git reset HEAD~1'
alias grsh1='git reset --soft HEAD~1'

alias ga='git add'
alias gA='git add -A'

alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -a'
alias gcam='git add -A && git commit -m'
alias gfrb='git fetch origin && git rebase origin/master'

alias gxn='git clean -dn'
alias gx='git clean -df'

alias gsha='git rev-parse HEAD | pbcopy'

alias ghci='gh run list -L 1'

alias gmab='git merge --abort'
alias grbsab='git rebase --abort'

# git merge squash
function gms() {
  local branch=${1:-"origin/main"}
  local commit_msg=${2:-"Merge changes from $branch"}
  
  echo "Fetching latest remote code..."
  git fetch origin
  
  echo "Merging changes from $branch into current branch and squashing into a single commit..."
  git merge --squash "$branch"
  
  if [ $? -eq 0 ]; then
      git commit -m "$commit_msg"
      echo "Successfully merged changes from $branch into a single commit"
  else
      echo "Merge failed, please resolve conflicts and commit manually"
  fi
}

function glp() {
  git --no-pager log -$1
}

function gd() {
  if [[ -z $1 ]] then
    git diff --color | diff-so-fancy
  else
    git diff --color $1 | diff-so-fancy
  fi
}

function gdc() {
  if [[ -z $1 ]] then
    git diff --color --cached | diff-so-fancy
  else
    git diff --color --cached $1 | diff-so-fancy
  fi
}

function findGitLog() {
  git log --pretty=format:"%h %s" | grep -i "$1"
}

# -------------------------------- #
# Directories
#
# I put
# `~/i` for my projects
# `~/open-codes` for forks
# `~/r` for reproductions
# -------------------------------- #

function i() {
  cd ~/i/$1
}

function repros() {
  cd ~/r/$1
}

function forks() {
  cd ~/open-codes/$1
}

function pr() {
  if [ $1 = "ls" ]; then
    gh pr list
  else
    gh pr checkout $1
  fi
}

function dir() {
  mkdir $1 && cd $1
}

function clone() {
  if [[ -z $2 ]] then
    hub clone "$@" && cd "$(basename "$1" .git)"
  else
    hub clone "$@" && cd "$2"
  fi
}

# Use cursor instead of code
alias code=cursor

# Clone to ~/i and cd to it
function clonei() {
  i && clone "$@" && code . && cd ~2
}

function cloner() {
  repros && clone "$@" && code . && cd ~2
}

function clonef() {
  forks && clone "$@" && code . && cd ~2
}

function codei() {
  i && code "$@" && cd -
}

function serve() {
  if [[ -z $1 ]] then
    live-server dist
  else
    live-server $1
  fi
}

# Find and kill node processes
# Usage: kns [port]
# Example: kns      # Kill all node processes
#          kns 3000 # Kill node processes running on port 3000
function kill-node-server() {
  if [[ -z $1 ]]; then
    # If no port specified, kill all node processes
    ps aux | grep 'node' | grep -v 'grep' | awk '{print $2}' | xargs kill -9 2>/dev/null
    echo "All node processes have been terminated"
  else
    # If port specified, only kill processes on that port
    lsof -i :$1 | grep 'node' | awk '{print $2}' | xargs kill -9 2>/dev/null
    echo "Node processes on port $1 have been terminated"
  fi
}

alias kns="kill-node-server"

function sourcec() {
  # copy .zshrc to i/use/zshrc
  cp ~/.zshrc ~/i/use/.zshrc
  # source .zshrc
  source ~/.zshrc
}


# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# rust cargo
export PATH="$HOME/.cargo/bin:$PATH"
