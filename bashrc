#!/usr/bin/env bash

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return ;;
esac

export DOTFILES="$HOME/dotfiles"

for rcfile in "$DOTFILES"/bashrc.d/*.sh; do
  # shellcheck disable=SC1090
  source "$rcfile"
done


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export NODE_EXTRA_CA_CERTS="$HOME/Documents/Sud/certs/AllCACertificates.pem"

# Uncomment below lines if you want to use Powerline Theme
# Add this to your PATH if it’s not already declared
#export PATH=$PATH:$HOME/.local/bin
 
# Powerline configuration
#if [ -f $HOME/.local/lib/python3.13/site-packages/powerline/bindings/bash/powerline.sh ]; then
#    $HOME/.local/bin/powerline-daemon -q
#    POWERLINE_BASH_CONTINUATION=1
#    POWERLINE_BASH_SELECT=1
#    source $HOME/.local/lib/python3.13/site-packages/powerline/bindings/bash/powerline.sh
#fi
#
#
#Following is for Oh-My-Posh theme
eval "$(oh-my-posh init bash --config $(brew --prefix oh-my-posh)/themes/powerlevel10k_classic.omp.json)"
