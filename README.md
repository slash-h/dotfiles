# My dotfiles

Config for shell (bash), neovim, tmux, and macOS window management
(aerospace + sketchybar + jankyborders). Managed with [GNU Stow].

## Setup on a new machine

```bash
brew install stow                 # if not already installed
git clone <this-repo> ~/dotfiles  # MUST live at ~/dotfiles (paths are hardcoded)
cd ~/dotfiles
./dotsetup                        # symlink the default set into ~
```

`./dotsetup` with no args stows the default packages (uses **nvim-minimal**).
Pass package names to stow a specific subset:

```bash
./dotsetup nvim-lazyvim git       # only these
./dotsetup -D nvim-minimal        # unstow (remove symlinks) a package
```

## Packages

| Package        | Links into                                       |
|----------------|--------------------------------------------------|
| bash           | ~/.bashrc ~/.bash_profile ~/.inputrc ~/.bashrc.d/ |
| npm            | ~/.npmrc                                         |
| git            | ~/.gitconfig (see note below)                    |
| prettier       | ~/.prettierrc.json                               |
| nvim-minimal   | ~/.config/nvim  (default)                        |
| nvim-lazyvim   | ~/.config/nvim  (alternative)                    |
| nvim-native    | ~/.config/nvim  (alternative)                    |
| tmux           | ~/.config/tmux/tmux.conf                         |
| aerospace      | ~/.config/aerospace/                             |
| sketchybar     | ~/.config/sketchybar/                            |
| jankyborders   | ~/.config/jankyborders/                          |
| ghostty        | ~/.config/ghostty/                               |
| lf             | ~/.config/lf/                                    |
| gh             | ~/.config/gh/config.yml                          |

> The three `nvim-*` packages all target `~/.config/nvim` — stow only one at a
> time. Switch with `./dotsetup -D nvim-minimal && ./dotsetup nvim-lazyvim`
> (replace package names as needed).

## Notes

- The repo **must** be cloned to `~/dotfiles` (hardcoded in `bashrc` and
  `bashrc.d/*.sh`).
- `git`: `.gitconfig` is git-ignored (machine-local). Copy the template and
  edit your name/email: `cp git/.gitconfig.example git/.gitconfig`, then
  `./dotsetup git`.
- `gh`: auth tokens are **not** stored here — run `gh auth login` on the new
  machine to generate `~/.config/gh/hosts.yml`.
- Install `bat` (aka `batcat`) for colorful previews in the `lf` file manager.

[GNU Stow]: https://www.gnu.org/software/stow/
