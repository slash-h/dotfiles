# Dotfiles → GNU Stow migration plan

Status: **planned, not yet executed.** Run later to avoid disrupting the live session.

## Context / constraints (verified)

- Repo **must** stay at `~/dotfiles` — hardcoded in `bashrc:13`, `bashrc.d/50-globals.sh:33`,
  `bashrc.d/30-prompt.sh:3`, `bashrc.d/60-aliases.sh:29`. Stow target = parent of stow dir = `~`,
  so keeping packages *inside* `~/dotfiles` preserves this.
- `bashrc.d/*.sh` is currently sourced by absolute path (`$DOTFILES/bashrc.d`), not via a symlink.
  Decision: move it into the `bash` package (stowed to `~/.bashrc.d`) and update the 2 source paths.
- `config/bash.d/functions.sh` is a **dead duplicate** of `bashrc.d/70-functions.sh` (defines
  `cecho`/`chevrons`/`git_info`, all already in 70-functions.sh which the live PS1 uses). Sourced nowhere → **drop**.
- `git-prompt.sh` is **unused** (only self-references; prompt uses custom `git_info`, not `__git_ps1`) → **delete**.
- `gitconfig` and `config/gh/hosts.yml` are git-ignored (machine-local / secrets).
- Stow is **not installed** yet.

### Current `~` state at planning time (messy — will be normalized)
- Symlinks → repo: `.bashrc .bash_profile .inputrc .gitconfig .config/{aerospace,sketchybar,lf,gh,nvim}`
  (note: `.config/nvim` → `config/nvim/LazyVim/`).
- Real file: `.npmrc`. Real dirs: `.config/ghostty`, `.config/tmux` (only `.DS_Store`),
  `.config/nvim_native` (third nvim variant — not yet in the repo).
- Absent: `.prettierrc.json`, `.config/jankyborders`, `.config/bash.d`.

## Resolved decisions
1. nvim default = **nvim-minimal**; nvim-lazyvim and nvim-native are swappable alternatives.
   All three target `~/.config/nvim` — only one stowed at a time. nvim-native is not yet in the
   repo (real dir at `~/.config/nvim_native`); it will be copied into the package as `.config/nvim/`
   and added to git (no `git mv` — currently untracked outside the repo).
2. `config/bash.d/` dropped (dead dup).
3. `ghostty` brought under management via `stow --adopt`.
4. Secrets: `hosts.yml` excluded from Stow (regenerate via `gh auth login`); `gitconfig` stowed
   *if present* + tracked `git/.gitconfig.example` for fresh machines.
5. `git-prompt.sh` deleted.

## Execution notes (read before starting)

- **Not disruption-free during execution.** Step 2 (`git mv`) moves the targets the current `~`
  symlinks point at, so every existing symlink goes dangling until Step 5 (`stow`) re-creates them.
- **Running apps keep running** (sketchybar, aerospace, jankyborders, ghostty, tmux, current shell
  hold config in memory), but during the window: reloads/restarts fail and **new shells can't source
  `~/.bashrc`**. After Step 5 everything is restored to the new paths.
- Run the whole thing in **one uninterrupted sitting**, keep the current terminal open (don't rely on
  spawning fresh shells mid-way), and don't leave it half-done.

## Steps

### 0. Backup first (mandatory)
```bash
BK=~/dotfiles-migration-backup-$(date +%Y%m%d-%H%M%S)
mkdir -p "$BK"

# 1. Full snapshot of the repo (tracked + untracked + git-ignored working files, incl. secrets)
cp -a ~/dotfiles "$BK/repo"

# 2. Snapshot the ~ entries the migration removes/replaces.
#    cp -a preserves symlinks AS symlinks (records current link->target mapping)
#    and copies real dirs (ghostty, tmux) by content.
cp -a ~/.bashrc ~/.bash_profile ~/.inputrc ~/.gitconfig ~/.npmrc "$BK/" 2>/dev/null
mkdir -p "$BK/config"
cp -a ~/.config/{aerospace,sketchybar,lf,gh,nvim,nvim_native,ghostty,tmux,jankyborders} "$BK/config/" 2>/dev/null

# 3. Give git a clean restore point (there are uncommitted changes at planning time:
#    sketchybar edits + untracked config/sketchybar/.backup-*/ and images/). Commit or stash them.
cd ~/dotfiles && git status
```

### Rollback (if anything breaks)
```bash
cd ~/dotfiles && stow -D <packages>                 # remove any new symlinks stow created
rm -rf ~/dotfiles && cp -a "$BK/repo" ~/dotfiles     # restore repo
cp -a "$BK/.bashrc" "$BK/.bash_profile" "$BK/.inputrc" "$BK/.gitconfig" "$BK/.npmrc" ~/
cp -a "$BK/config/"* ~/.config/                      # restore old ~ symlinks/real dirs
```
Backup preserves the old symlinks exactly, so restoring returns you to today's working state.

### 1. Install
```bash
brew install stow
```

### 2. Restructure into per-app packages (use `git mv` to keep history)
```
bash/          .bashrc .bash_profile .inputrc .bashrc.d/(from bashrc.d/)
npm/           .npmrc
git/           .gitconfig (stow-if-present) + .gitconfig.example (tracked)
prettier/      .prettierrc.json
nvim-minimal/  .config/nvim/  (from config/nvim/minimal/)           <- DEFAULT
nvim-lazyvim/  .config/nvim/  (from config/nvim/LazyVim/)
nvim-native/   .config/nvim/  (from ~/.config/nvim_native — cp + git add)
tmux/          .config/tmux/tmux.conf
aerospace/     .config/aerospace/aerospace.toml
sketchybar/    .config/sketchybar/  (+ .stow-local-ignore: \.backup-.*)
jankyborders/  .config/jankyborders/bordersrc
ghostty/       .config/ghostty/config   (adopt live copy)
lf/            .config/lf/{lfrc,previewer}
gh/            .config/gh/config.yml     (hosts.yml excluded)
```
Dropped: `config/bash.d/`, `git-prompt.sh`. Unmanaged at root: `README.md`, `dotsetup`, `.gitignore`.

### 3. Edit 2 hardcoded paths (bashrc.d now lives at `~/.bashrc.d`)
- `bash/.bashrc:15` → `for rcfile in "$HOME"/.bashrc.d/*.sh`
- `bash/.bashrc.d/30-prompt.sh:3` → `source "$HOME"/.bashrc.d/70-functions.sh`
- Leave `DOTFILES=$HOME/dotfiles` and `alias d='cd $DOTFILES'` unchanged.

### 4. Ignore noise
```bash
find . -name .DS_Store -delete
printf '\\.DS_Store\n' >> ~/.stow-global-ignore
# sketchybar/.stow-local-ignore contains:  \.backup-.*
```

### 5. Clear conflicts, then stow
```bash
# remove stale symlinks
rm ~/.bashrc ~/.bash_profile ~/.inputrc ~/.gitconfig
rm ~/.config/aerospace ~/.config/sketchybar ~/.config/lf ~/.config/gh ~/.config/nvim
# remove real leftovers (back up first if unsure)
rm ~/.npmrc ; rm -rf ~/.config/tmux ~/.config/nvim_native

cd ~/dotfiles
stow -t ~ bash npm git prettier nvim-minimal tmux aerospace sketchybar jankyborders lf gh
stow -t ~ --adopt ghostty
git diff ghostty/          # review content adopted from live ~/.config/ghostty
```
Verify: links resolve, `source ~/.bashrc` (prompt OK), nvim + sketchybar load.

### 6. Rewrite `dotsetup` as a stow wrapper
- Installs stow if missing (`command -v stow || brew install stow`).
- `./dotsetup` → stows default set (uses **nvim-minimal**), skips `git` if no `.gitconfig`.
- `./dotsetup <pkg...>` → stow named packages. Flags (e.g. `-D` to unstow) passed through to stow.
- To switch nvim profile: `./dotsetup -D nvim-minimal && ./dotsetup nvim-lazyvim` (or nvim-native).
- Update README (see below).

---

## Proposed README.md

```markdown
# My dotfiles

Config for shell (bash), neovim, tmux, and macOS window management
(aerospace + sketchybar + jankyborders). Managed with [GNU Stow].

## Setup on a new machine

\```bash
brew install stow                 # if not already installed
git clone <this-repo> ~/dotfiles  # MUST live at ~/dotfiles (paths are hardcoded)
cd ~/dotfiles
./dotsetup                        # symlink the default set into ~
\```

`./dotsetup` with no args stows the default packages (uses **nvim-minimal**).
Pass package names to stow a specific subset:

\```bash
./dotsetup nvim-lazyvim git       # only these
./dotsetup -D nvim-minimal        # unstow (remove symlinks) a package
\```

## Packages

| Package        | Links into                          |
|----------------|-------------------------------------|
| bash           | ~/.bashrc ~/.bash_profile ~/.inputrc ~/.bashrc.d/ |
| npm            | ~/.npmrc                            |
| git            | ~/.gitconfig (see note below)       |
| prettier       | ~/.prettierrc.json                  |
| nvim-minimal   | ~/.config/nvim  (default)           |
| nvim-lazyvim   | ~/.config/nvim  (alternative)       |
| nvim-native    | ~/.config/nvim  (alternative)       |
| tmux           | ~/.config/tmux/tmux.conf            |
| aerospace      | ~/.config/aerospace/                |
| sketchybar     | ~/.config/sketchybar/               |
| jankyborders   | ~/.config/jankyborders/             |
| ghostty        | ~/.config/ghostty/                  |
| lf             | ~/.config/lf/                       |
| gh             | ~/.config/gh/config.yml             |

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
```
