## Installation

Clone this repository

    `git clone https://github.com/wget/dotvim.git ~/.vim`

Create symlinks

    `ln -s ~/.vim/vimrc ~/.vimrc`

Switch to the "~/.vim" directory and fetch git submodules with

    `git submodule init`
    `git submodule update`

## Add a new plugin

    Edit the vimrc configuration file and add a 
    `Bundle GITHUB_USERNAME/NAME_OF_PROJECT`
    statement and type
    `:BundleInstall`

## Remove an existing plugin

    Edit the vimrc configuration file and remove a 
    `Bundle GITHUB_USERNAME/NAME_OF_PROJECT`
    statement and type
    `:BundleClean` and confirm
    
## Dependencies
    
For Powerline users, make sure your terminal emulator is using UTF-8 ancoding.
If you can't make it, install the ttf font available at the root 
of this directory and enable it as defaut font in your terminal emulator.
