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
export CF_HOME=$HOME
#export VISUAL="nvim"
#export EDITOR="nvim"


#Following is for Oh-My-Posh theme
#eval "$(oh-my-posh init bash --config $(brew --prefix oh-my-posh)/themes/powerlevel10k_classic.omp.json)"
#eval "$(oh-my-posh init bash --config $(brew --prefix oh-my-posh)/themes/custom_negligible.omp.json)"

## Kali-Linux prompt
#PS1="\[\e]0;\u@\h: \w\a\]\[\033[;32m\]┌──${debian_chroot:+($debian_chroot)──}${VIRTUAL_ENV:+(\[\033[0;1m\]$(basename $VIRTUAL_ENV)\[\033[;32m\])}(\[\033[1;34m\]\u㉿\h\[\033[;32m\])-[\[\033[0;1m\]\w\[\033[;32m\]]\n\[\033[;32m\]└─\[\033[1;34m\]\$\[\033[0m\]"
