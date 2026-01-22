# AGENTS.md

This repository manages dotfiles using GNU Stow. Configuration files are organized in feature-specific directories.

## Build/Lint/Test Commands

### Syntax Checking Bash Scripts
```bash
# Check syntax without executing
bash -n bashrc_check.sh

# Run with shellcheck (if available)
shellcheck bashrc_check.sh

# Test the bashrc setup script
./bashrc_check.sh --dry-run  # Preview changes
./bashrc_check.sh            # Apply changes
```

### Testing Stow Operations
```bash
# Preview what stow would do (simulate)
stow -n -v tmux

# Stow a specific configuration
stow tmux
stow bash
stow alias-kubectl

# Unstow (remove symlinks)
stow -D tmux

# Restow (update symlinks)
stow -R tmux
```

### Verification
```bash
# Verify symlinks are created correctly
ls -la ~/.tmux.conf  # Should link to ~/.dotfiles/tmux/.tmux.conf
ls -la ~/.bashrc.d   # Should show symlinks to bash/.bashrc.d/
```

## Code Style Guidelines

### Bash Scripts

**Shebang and Safety:**
- Always start with `#!/bin/bash`
- Enable strict mode: `set -euo pipefail`

**Functions:**
- Use snake_case naming: `parse_git_branch`, `parse_git_dirty`
- Define functions with `function keyword` or `name()` format
- Use descriptive names that explain purpose

**Variables:**
- Environment variables: UPPERCASE (`HISTSIZE`, `CUSTOM_DIR`, `PATH`)
- Local variables: UPPERCASE for script-level, lowercase for function-local
- Export only when necessary: `export PATH="$PATH:$CUSTOM_DIR"`
- Unset temporary variables after use: `unset CUSTOM_DIR`

**Comments:**
- Use `##### SECTION NAME ######` for major sections
- Brief inline comments for complex logic
- Comment sections in configuration files (tmux, etc.)

**Conditionals:**
- Use `[[ ]]` for string comparisons in bash scripts
- Use `[ ]` for POSIX compatibility in .bashrc files
- Quote all variable expansions: `"$VAR"`

**Error Handling:**
- Send error messages to stderr: `>&2`
- Check file/directory existence before operations: `[ -d "$DIR" ]`
- Use temporary files with unique names: `${BASHRC_FILE}.tmp.$$`
- Always clean up temp files: `trap 'rm -f "$TEMP_FILE"' EXIT`

**Indentation:**
- Bash scripts: 2 spaces
- Configuration files: no indentation or context-based (tmux)

### Directory Structure

**Feature-based organization:**
- Each tool/app gets its own directory: `tmux/`, `bash/`, `alias-kubectl/`
- Files mirror target structure (e.g., `.tmux.conf`, `.bashrc.d/`)
- Subdirectories for grouped configs: `.bashrc.d/` contains multiple `.bashrc` files

**File Naming:**
- Bash snippets: `feature.bashrc` extension
- Aliases: `<tool>_alias.bashrc` pattern
- Dotfiles: Start with `.` (e.g., `.tmux.conf`, `.terraformrc`)

### Configuration Files

**Tmux (.tmux.conf):**
- Group by sections: General Options, Key Bindings, Pane Appearance
- Use `#` comments for explanations
- Key bindings: `bind` and `unbind` on separate lines
- Set options with `set -g` or `set-option`

**History (.bashrc.d/history.bashrc):**
- Configure `HISTSIZE`, `HISTFILESIZE`
- Enable `histappend` with `shopt -s`
- Set `HISTTIMEFORMAT` for timestamps
- Use `PROMPT_COMMAND` for history sync

**Aliases:**
- Keep simple and focused
- One alias per file when possible
- Include completion if needed: `complete -o default -F __start_kubectl k`

### Environment Setup

**Path Management:**
- Check directory exists before adding to PATH
- Avoid duplicate PATH entries with `[[ ":$PATH:" != *":$CUSTOM_DIR:"* ]]`
- Append to PATH: `export PATH="$PATH:$CUSTOM_DIR"`

**Prompt:**
- Use escape codes for colors: `\[\e[38;5;Nm\]`
- Git branch info with status indicators
- Multi-line prompt for clarity

### Terraform Configuration

**Provider Mirroring:**
- Use `filesystem_mirror` for local providers
- Fallback to `network_mirror` for remote
- Format: HCL with 2-space indentation
