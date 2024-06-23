#!/bin/zsh

SYSTEM_PYTHON3="/usr/bin/python3"

function set_up_PATH_for_pip {
    # This sets up the PATH variable by evaluating something like:
    # `export PATH="$HOME/Library/Python/3.9/bin:/opt/homebrew/bin:$PATH"`

    eval $(\
        $SYSTEM_PYTHON3 -c 'import sys; info = sys.version_info; print(f"export PATH='$HOME/Library/Python/{info.major}.{info.minor}/bin:/opt/homebrew/bin:$PATH'")'
    )
}

function upgrade_pip {
    $SYSTEM_PYTHON3 -m pip install --upgrade pip
}

function install_ansible {
    $SYSTEM_PYTHON3 -m pip install ansible
}

function install_dependencies {
    ansible-galaxy install -r requirements.yml
}

function run_playbook {
    ansible-playbook -K main.yml
}

set_up_PATH_for_pip
upgrade_pip
install_ansible
install_dependencies
run_playbook
