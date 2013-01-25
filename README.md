# Installation

## Clone this repository

    `git clone git://URL_GIT ~/.vim`

## Create symlinks

    `ln -s ~/.vim/.vimrc ~/.vimrc`

## Switch to the "~/.vim" directory and fetch sumodules with

    `git submodule init`
    `git submodule update`

# Add a new plugin

    `git submodule add THE_NEW_GIT_URL DESTINATION_NAME`

# To remove an existing plugin, all commands are made in the superproject.

## Short method (shortest one):
    
    `git rm --cached YOUR_SUBMODULE_PATH`

    This option is enough as the entries from the .gitmodules file aren't
    relevant for modules to exist. The only commands looking at that file
    are:
    - `git submodule init`
    - and `git submodule sync`

## Long and clean method:

    - Edit/delete .gitmodules to remove the submodule. 
    - To remove the files specific to your module
        `rm -rf YOUR_SUBMODULE_PATH`
    - To ask the superproject git repository to untrack the module
        `git rm -f --cached YOUR_SUBMODULE_PATH`
    - Commit your changes to the superproject
        `git commit -am "Removed submodules!"`
    - Inspect .git/config for "submodule" entries to remove. 
    
# Optional notes
    
    For Powerline add-on users, install the ttf font available at the root 
    of this directory and enable it as defaut font in your terminal emulator.
