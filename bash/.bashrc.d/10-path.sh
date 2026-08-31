if [[ "$(uname -s)" == "Darwin" ]]; then
  export PATH="/usr/local/opt/openjdk/bin:$PATH"
  export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
  export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
fi

# Add dotfiles scripts path and subpaths
#while read -r path; do
#  export PATH="$PATH:$path"
#done <<< "$(find "$DOTFILES/scripts" -type d)"

# Have my user-specific bin dir take priority
export PATH="$HOME/bin:$PATH"

# Add krew for kubectl
#export PATH="${KREW_ROOT:-$HOME/.config/krew}/bin:$PATH"
