# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A macOS dotfiles repository. Config files are manually copied to their home directory locations (no symlinks, no automation). After editing any config here, copy it to `~` to apply.

## Deployment Commands

```bash
cp aerospace.toml ~/.aerospace.toml
cp tmux.conf ~/.tmux.conf
cp zshrc ~/.zshrc
cp zshenv.example ~/.zshenv      # then fill in tokens, chmod 600
cp gitconfig ~/.gitconfig
cp config.ghostty ~/.config/ghostty/config
# nvim/ -> ~/.config/nvim/
```

## Config Files and Their Targets

| Repo file | Deploys to | Notes |
|---|---|---|
| `aerospace.toml` | `~/.aerospace.toml` | AeroSpace tiling WM. Reload: `alt-shift-;` then `esc` |
| `tmux.conf` | `~/.tmux.conf` | Prefix is `Ctrl-a`. Install plugins: `Ctrl-a + I` |
| `zshrc` | `~/.zshrc` | Oh-My-Zsh with lazy-loaded NVM/Conda |
| `zshenv.example` | `~/.zshenv` | Template for private tokens (never commit real values) |
| `gitconfig` | `~/.gitconfig` | Uses nvim as editor, rebase on pull |
| `config.ghostty` | Ghostty config | Catppuccin Mocha, 75% opacity |
| `nvim/` | `~/.config/nvim/` | LazyVim framework |
| `vscode-settings-user.json` | VS Code user settings | |

## Conventions

- **Theme**: Catppuccin (Mocha/Macchiato) across all tools
- **TOML formatting**: The nvim TOML formatter strips section indentation to flat style — this is expected and valid
- **Secrets**: Go in `~/.zshenv` (from `zshenv.example`), never committed. The `.gitignore` only excludes `.DS_Store`
- **Commit messages**: Use conventional format with scope — `feat(tmux): ...`, `ref(zsh): ...`, `chore: ...`
- **Zsh performance**: NVM and Conda are lazy-loaded; completions are cached in `zsh/` directory. Don't add eager-loading of heavy tools

## Key Architecture Decisions

- **tmux prefix**: `Ctrl-a` (not default `Ctrl-b`), with tmux-tilit plugin for tiling via `Alt-space`
- **AeroSpace**: `alt` is the primary modifier. `alt-shift-;` enters service mode, `alt-shift-enter` enters apps mode. App launchers are direct bindings (e.g., `alt-g` for Ghostty)
- **NVM auto-switch**: The `chpwd` hook in zshrc auto-loads `.nvmrc` on directory change, lazy-loading NVM only when needed
