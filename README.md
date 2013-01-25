## Installation

### Clone this repository

    `git clone https://github.com/wget/dotvim.git ~/.vim`

### Create symlinks

    `ln -s ~/.vim/vimrc ~/.vimrc`

### Switch to the "~/.vim" directory and fetch sumodules with

    `git submodule init`
    `git submodule update`

## Add a new plugin

    `git submodule add git://URL_OF_THE_REPOSITORY_TO_ADD DESTINATION_NAME`

## Remove an existing plugin

All commands are made from the superproject directory.

### Short method (shortest one):
    
`git rm --cached YOUR_SUBMODULE_PATH`

This option is enough as the entries from the `.gitmodules` file aren't
relevant for modules to exist. The only commands looking at that file
are:
- `git submodule init`
- and `git submodule sync`

### Long and clean method:

- Edit/delete `.gitmodules` to remove the submodule location.
- Remove the files specific to your module
    `rm -rf YOUR_SUBMODULE_PATH`
- Ask the superproject git repository to untrack the module
    `git rm -f --cached YOUR_SUBMODULE_PATH`
- Commit your changes to the superproject
    `git commit -am "Removed submodules!"`
- Inspect `.git/config` for "submodule" entries to remove. 
    
## Dependencies
    
For Powerline users, make sure your terminal emulator is using UTF-8 ancoding.
If you can't make it, install the ttf font available at the root 
of this directory and enable it as defaut font in your terminal emulator.
