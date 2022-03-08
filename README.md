# ansible-macOS-playbook

This playbook installs and configures most of the software I use on my Mac.

## Installation

1. Ensure Apple's command line tools are installed (`xcode-select --install` to launch the installer).
2. [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html):
  1. Run the following command to add Python 3 to your $PATH: `export PATH="$HOME/Library/Python/3.8/bin:/opt/homebrew/bin:$PATH"`
  2. Upgrade Pip: `sudo pip3 install --upgrade pip`
  3. Install Ansible: `pip3 install ansible`

## Credits

This project is heavily inspired by other people's work, namely:

- [@geerlingguy](https://github.com/geerlingguy) 's [Mac Development Ansible Playbook](https://github.com/geerlingguy/mac-dev-playbook)
