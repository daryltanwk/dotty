# The Duckie Dotfile Repository

I have dotfiles. I store dotfiles.

## Pre-requisites

We need `stow`. So get `stow`

```bash
sudo apt install -y stow
```

## Usage

This repository uses GNU Stow to manage dotfiles. Stow creates symbolic links from the files in this repository to your home directory, keeping your home directory clean and allowing you to manage your dotfiles in a version-controlled way.

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/daryltanwk/dotty.git ~/.dotfiles
    ```

1.  **Navigate to the dotfiles directory:**

    ```bash
    cd ~/.dotfiles
    ```

1.  **Append snippet to `~/.bashrc` file**

    ```bash
    #...rest of the .bashrc file...

    # Tells bash to loop through the ~/.bashrc.d/ folder to look for files with the .bashrc extension and sources them
    for file in ~/.bashrc.d/*.bashrc;
    do
    source $file
    done
    ```

1.  **Stow the desired dotfiles:**
    For each set of dotfiles you want to install (e.g., `tmux`), run the `stow` command:

    ```bash
    stow tmux
    ```

    This command will create symbolic links in your home directory (`~`) pointing to the files within the `tmux` directory in your dotfiles repository (e.g., `~/.tmux.conf` will link to `~/.dotfiles/tmux/.tmux.conf`).

    Repeat this step for any other dotfile directories you have in this repository (e.g., `stow bash`).

## Adding New Dotfiles

To add new dotfiles or configurations:

1.  Create a new directory in the `~/.dotfiles` repository for the application or configuration (e.g., `nvim` for Neovim).
2.  Place the configuration files inside this new directory, mirroring the structure they would have in your home directory. For example, if your Neovim config is `~/.config/nvim/init.vim`, you would place it in `~/.dotfiles/nvim/.config/nvim/init.vim`.
3.  Commit your changes to the repository.
4.  On any machine where you want to deploy these new dotfiles, pull the latest changes and run `stow <new_directory_name>` (e.g., `stow nvim`).

## Removing Dotfiles

To remove dotfiles managed by stow, use the `-D` flag:

```bash
stow -D tmux
```

This will remove the symbolic links created by `stow tmux` from your home directory. The original files in the `~/.dotfiles/tmux` directory will remain untouched.
