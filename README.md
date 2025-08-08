# ansible-macOS-playbook

I try my best to automate as much as I can to set up my Macs for development work.

## Of course, there is an install script 😃️️

1. Clone this repo
2. Ensure Apple's command line tools are installed
  1. You can either run `xcode-select --install` to launch the installer.
  2. Or you can run `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` to install brew yourself, which also installs the command line tools.
3. Run the install script `zsh install.zsh`

## Manual Installation

This guide is adapted from [@geerlingguy](https://github.com/geerlingguy) 's [Mac Development Ansible Playbook](https://github.com/geerlingguy/mac-dev-playbook) as pointed out in the Credits section.

1. Ensure Apple's command line tools are installed.
  1. You can either run `xcode-select --install` to launch the installer.
  2. Or you can run `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"` to install brew yourself.
2. [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html):
    1. Run the following command to add Python 3 to your $PATH: `export PATH="$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:$PATH"`
        * Note: The version of Python might change when you are running the script. Check the output of `python3 --version` for your Python 3's major and minor version numbers, i.e. `3.9` in this command.
    2. Upgrade Pip: `python3 -m pip --upgrade pip`
    3. Install Ansible: `python3 -m pip install ansible`
3. Clone or download this repository.
4. Run `ansible-galaxy install -r requirements.yml` inside this directory to install required Ansible roles..
5. Run `ansible-playbook main.yml --ask-become-pass` inside this directory. Enter your macOS account password when prompted for the 'BECOME' password.

> Note: If some Homebrew commands fail, you might need to agree to Xcode's license or fix some other Brew issue. Run brew doctor to see if this is the case.

## Structure (roles-first)

This playbook is now split into composable roles. The entry point `main.yml` lists roles in execution order.

Roles in this repo:

- `preflight`: quick sudo/password check and hello.
- `dotfiles`: clone/update `TheClooneyCollection/dotfiles` into `~/`.
- `ssh`: optionally generate SSH keypair (gated by `generate_ssh`).
- `homebrew_base`: installs/configures Homebrew via `geerlingguy.mac.homebrew` and registers `brew_prefix`.
- `dev_tools`: command-line formulae (git, fzf, ripgrep, languages, swift tools, etc.).
- `casks`: GUI apps and utilities.
- `shared_fonts`: shared font installation helper (kept as-is, separate role in `roles/shared_fonts`).
- `emacs`: Emacs Plus + Spacemacs setup.
- `vim`: Vim + YouCompleteMe bootstrap/compile.
- `python_env`: pip `ansible`, install `poetry`, run `poetry install`.
- `shell_fish`: default shell to fish.
- `fzf`: run fzf installer.
- `folders`: create `~/Source/{Projects,Forks,Work}`.
- `macos_finder`: Finder defaults.
- `macos_stage_manager`: Stage Manager defaults.
- `macos_dock`: Dock & Mission Control defaults.

Global variables remain defined at the play level in `main.yml` (e.g., `homebrew_user`, `homebrew_group`, `generate_ssh`, `ssh_*`).

## Tags and targeted runs

Common tags: `homebrew`, `homebrew-setup`, `dotfiles`, `ssh`, `spacemacs`, `vim`, `python`, `poetry`, `fishshell`, `fzf`, `folder-structure`, `finder`, `stage-manager`, `dock`.

Examples:

- List tags: `ansible-playbook -i inventory --list-tags main.yml`
- Syntax check: `ansible-playbook -i inventory --syntax-check main.yml`
- Dry run: `ansible-playbook -i inventory -K --check --diff main.yml`
- Homebrew base + dev tools + casks: `ansible-playbook -i inventory -K main.yml --tags homebrew`
- Fonts only: `ansible-playbook -i inventory -K main.yml --tags homebrew` (ensures brew) then `--tags fonts` if you add a `fonts` tag to your run, or run entire play (this repo's fonts are invoked via role `shared_fonts`).
- macOS UI defaults: `ansible-playbook -i inventory -K main.yml --tags finder,stage-manager,dock`
- Editors: `ansible-playbook -i inventory -K main.yml --tags spacemacs,vim`
- SSH generation: `ansible-playbook -i inventory -K main.yml --tags ssh -e generate_ssh=true`

Notes on dependencies when targeting:

- Some roles rely on `homebrew_base` to have run (because it registers `brew_prefix` and ensures Homebrew): `emacs`, `python_env`, and `fzf` in particular. When running these tags alone, include `homebrew` too, e.g.: `--tags homebrew,spacemacs` or `--tags homebrew,python`.
- `casks` and `dev_tools` also assume Homebrew is installed; include `--tags homebrew` if you are targeting them on a fresh machine.

## Credits

This project is inspired by other people's work, namely:

- [Jeff Geerling aka @geerlingguy](https://github.com/geerlingguy) 's [Mac Development Ansible Playbook](https://github.com/geerlingguy/mac-dev-playbook)
- [Patrick Quinn-Graham aka @thepatrick](https://github.com/thepatrick)'s [inventory](https://github.com/thepatrick/inventory)
