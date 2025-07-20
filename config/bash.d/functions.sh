#!/usr/bin/env bash

# Print a message in color.
# https://bytefreaks.net/gnulinux/bash/cecho-a-function-to-print-using-different-colors-in-bash
cecho() {
  declare message=${1:-""}
  declare color=${2:-"default"}

  declare -A colors
  colors=(
    [default]="\e[39m"
    [black]="\e[30m"
    [red]="\e[31m"
    [green]="\e[32m"
    [yellow]="\e[33m"
    [blue]="\e[34m"
    [magenta]="\e[35m"
    [cyan]="\e[36m"
    [gray]="\e[37m"
    [light - red]="\e[91m"
    [light - green]="\e[92m"
    [light - yellow]="\e[93m"
    [light - blue]="\e[94m"
    [light - magenta]="\e[95m"
    [light - cyan]="\e[96m"
    [light - gray]="\e[97m"
  )

  color=${colors[$color]}

  echo -e "\x01${color}\x02${message}\x01\e[m\x02"
}

# Show colorful chevrons according to what season it is.
chevrons() {
  local date=""
  date=$(date)
  local chevrons="❯❯❯"

  case $date in
  # spring
  *Mar* | *Apr* | *May*)
    chevrons="$(cecho '❯' cyan)$(cecho '❯' green)$(cecho '❯' yellow)"
    ;;
  # summer
  *Jun* | *Jul* | *Aug*)
    chevrons="$(cecho '❯' green)$(cecho '❯' yellow)$(cecho '❯' red)"
    ;;
  # fall
  *Sep* | *Oct* | *Nov*)
    chevrons="$(cecho '❯' yellow)$(cecho '❯' red)$(cecho '❯' magenta)"
    ;;
  # winter
  *Dec* | *Jan* | *Feb*)
    chevrons="$(cecho '❯' magenta)$(cecho '❯' cyan)$(cecho '❯' green)"
    ;;
  *) ;;
  esac

  echo "$chevrons"
}

git_info() {

  declare -A colors
  colors=(
    [default]="\e[39m"
    [black]="\e[30m"
    [red]="\e[31m"
    [green]="\e[32m"
    [yellow]="\e[33m"
    [blue]="\e[34m"
    [magenta]="\e[35m"
    [cyan]="\e[36m"
    [gray]="\e[37m"
    [orange]="\e[33m"
    [light - red]="\e[91m"
    [light - green]="\e[92m"
    [light - yellow]="\e[93m"
    [light - blue]="\e[94m"
    [light - magenta]="\e[95m"
    [light - cyan]="\e[96m"
    [light - gray]="\e[97m"
  )

  local s=''
  local branchName=''

  # Check if the current directory is in a Git repository.
  git rev-parse --is-inside-work-tree &>/dev/null || return

  # Check for what branch we’re on.
  # Get the short symbolic ref. If HEAD isn’t a symbolic ref, get a
  # tracking remote branch or tag. Otherwise, get the
  # short SHA for the latest commit, or give up.
  branchName="$(git symbolic-ref --quiet --short HEAD 2>/dev/null ||
    git describe --all --exact-match HEAD 2>/dev/null ||
    git rev-parse --short HEAD 2>/dev/null ||
    echo '(unknown)')"

  # Early exit for Chromium & Blink repo, as the dirty check takes too long.
  # Thanks, @paulirish!
  # https://github.com/paulirish/dotfiles/blob/dd33151f/.bash_prompt#L110-L123
  repoUrl="$(git config --get remote.origin.url)"
  if grep -q 'chromium/src.git' <<<"${repoUrl}"; then
    s+='*'
  else
    # Check for uncommitted changes in the index.
    if ! $(git diff --quiet --ignore-submodules --cached); then
      s+='+'
    fi
    # Check for unstaged changes.
    if ! $(git diff-files --quiet --ignore-submodules --); then
      s+='!'
    fi
    # Check for untracked files.
    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
      s+='?'
    fi
    # Check for stashed files.
    if $(git rev-parse --verify refs/stash &>/dev/null); then
      s+='$'
    fi
  fi

  [ -n "${s}" ] && s=" [${s}]"

  #echo -e "${1}${branchName}${2}${s}";
  echo -e "${1}${colors[orange]}${branchName}${2}${colors[blue]}${s}"

}
