# 'source' this file from ~/.bashrc

color_prompt=yes
force_color_prompt=yes

test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias s='http-server -p 8080 -a 127.0.0.1 -c -1'

alias bazel="bazelisk"
export BAZEL="bazelisk"

# Coverage for a Go module.
alias tc='go test -v -coverprofile=/tmp/c.out && go tool cover -html=/tmp/c.out'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias allcls='for k in `git branch | sed s/^..//`; do echo -e `git log -1 --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k --`\\t"$k";done | sort'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

export GOROOT=$HOME/go
export GOPATH=$HOME/projects/golib
export EDITOR="code --wait"
#export PATH=$GOROOT/bin:$HOME/node/bin:$HOME/bin:$GOPATH/bin:$HOME/projects/swarming/client:$HOME/projects/clang/bin:$PATH:$HOME/projects/depot_tools

export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true

source "$HOME/jcgregorio/git-prompt/git-prompt.sh"
D=$'\033[m'
PINK=$'\033[38;5;213m'
GREEN=$'\033[38;5;2m'
ORANGE=$'\033[38;5;214m'
BLUE=$'\033[38;5;68m'

alias skia-public='gcloud container clusters get-credentials skia-public --zone us-central1-a --project skia-public; gcloud config set project skia-public'
alias skia-corp='gcloud container clusters get-credentials skia-corp --zone us-central1-a --project google.com:skia-corp; gcloud config set project google.com:skia-corp'
alias skia-switchboard='gcloud container clusters get-credentials skia-switchboard --zone us-central1-c --project skia-switchboard; gcloud config set project skia-switchboard'
__kube_ps1()
{
    if hash kubectl 2>/dev/null; then
      # Get current context
      CONTEXT=$(kubectl config current-context)
      # Strip off the prefix.
      CONTEXT=${CONTEXT##*_}

      if [ -n "$CONTEXT" ]; then
          printf "${GREEN}[${CONTEXT}] "
      fi
    fi
}

export PROMPT_COMMAND='history -a; history -c; history -r; __kube_ps1; __git_ps1 "${BLUE}\u${ORANGE}@\h${PINK} ${GREEN}\w${D}" " ${D}\n\\\$ "'
#export PS1='${BLUE}\u${ORANGE}@\h${PINK}$(__git_ps1 " (%s)")${GREEN} \W${D} \$ '

export CHROME_REMOTE_DESKTOP_DEFAULT_DESKTOP_SIZES=1280x850,2560x1700
