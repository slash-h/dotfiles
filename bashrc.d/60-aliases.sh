# All aliases in here
alias vi=nvim
#alias kitty=/Applications/kitty.app/Contents/MacOS/kitty
alias twt='[ "$TMUX" ] && tmux display-message -p "#W"'
alias tm='tmux attach-session -t $(basename "$PWD") || tmux new-session -s $(basename "$PWD")'
alias python=/usr/local/bin/python3
alias branch='git checkout -b'
#alias pr='git push --set-upstream origin $(git branch --show-current) && gh pr create --body'

# See https://superuser.com/questions/763071/show-whitespace-characters-in-printout
alias whitespace="sed 's/ /·/g;s/\t/￫/g;s/\r/§/g;s/$/¶/g'"

# GitHub CLI - issue management
#alias in='gh issue create'
#alias iv='gh issue view'
#alias ie='gh issue edit'
#alias ic='gh issue comment'
#alias i='gh issue list'

# Show directory symbol (/) and hidden directories
alias ls='ls -p -a --color=auto'

# Single char aliases
#alias k=kubectl
alias r=ranger
alias t='tmux -u'
alias lg=lazygit
alias d='cd $DOTFILES'
#alias r=reset

alias st='git status'
alias dpa='docker ps -a --format "table {{.Names}}\t{{.State}}\t{{.RunningFor}}\t{{.Networks}}\t{{.Mounts}}"'
alias dcl='docker context list'

alias gapi='gh api --paginate --cache 1h'

alias nvf='nvim $(fzf)'
alias pde='docker start pde && docker exec -it pde bash'
