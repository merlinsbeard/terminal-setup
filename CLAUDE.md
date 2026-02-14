# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A macOS dotfiles repository. Run `./install.sh` to install apps, then `./deploy.sh` to copy configs to `~`.

## Commands

```bash
./install.sh                     # Install required apps and tools
./install.sh --help              # Show what gets installed
./deploy.sh                      # Deploy all configs (with backup)
./deploy.sh zsh nvim tmux        # Deploy specific targets
./deploy.sh --no-backup          # Deploy without backing up existing files
./deploy.sh --list               # List available targets
```

`deploy.sh` backs up existing configs to `~/.dotfiles-backup/<timestamp>/` before overwriting.
Warns if a target app is not installed (but still copies the config).

## Conventions

- **Theme**: Catppuccin (Mocha/Macchiato) across all tools
- **TOML formatting**: The nvim TOML formatter strips section indentation to flat style — this is expected and valid
- **Secrets**: Go in `~/.zshenv` (from `zshenv.example`), never committed
- **Commit messages**: Use conventional format with scope — `feat(tmux): ...`, `ref(zsh): ...`, `chore: ...`
- **Zsh performance**: NVM and Conda are lazy-loaded; completions are cached in `zsh/` directory. Don't add eager-loading of heavy tools
- **CI**: Security workflow runs on push/PR — gitleaks, ShellCheck, dangerous pattern scan, syntax validation

## Key Architecture Decisions

- **tmux prefix**: `Ctrl-a` (not default `Ctrl-b`), with tmux-tilit plugin for tiling via `Alt-space`
- **AeroSpace**: `alt` is the primary modifier. `alt-shift-;` enters service mode, `alt-shift-enter` enters apps mode. App launchers are direct bindings (e.g., `alt-g` for Ghostty)
- **NVM auto-switch**: The `chpwd` hook in zshrc auto-loads `.nvmrc` on directory change, lazy-loading NVM only when needed
