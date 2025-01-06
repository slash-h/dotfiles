export FZF_DEFAULT_OPTS="--height=70% --layout=reverse --info=inline --preview 'cat {}' --border --margin=1 --padding=1 --color=bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9,header:#616E88,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1,fg+:#D8DEE9,prompt:#81A1C1,hl+:#81A1C1"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
if type rg &>/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob '"'"'!.git/'"'"
fi
