# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# Created by `pipx` on 2025-01-03 22:55:21
export PATH="$PATH:/Users/badgus/.local/bin"

# Bring in the bashrc stuff
[ -r $HOME/.bashrc ] && source $HOME/.bashrc

export BASH_SILENCE_DEPRECATION_WARNING=1

#below is for setting certificate in python3
CERT_PATH='/Users/badgus/Documents/Sud/certs/AllCACertificates.pem'
export SSL_CERT_FILE=${CERT_PATH}
export REQUESTS_CA_BUNDLE=${CERT_PATH}

