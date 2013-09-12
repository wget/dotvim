## Installation

1. Clone this repository:
   `$ git clone https://github.com/wget/dotvim.git ~/.vim`

2. Create symlinks:
   `$ ln -s ~/.vim/vimrc ~/.vimrc`

3. Install Vundle, the Vim plugin manager:
   `$ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle`

4. Start Vim and type `:BundleInstall` and press return, then wait for all plugin repositories to be cloned.

OPTIONAL:

5. As vim-airline is using special symbols, you'll have to patch/replace the font you are using in your terminal emulator. Here is a pack of fonts that have been already patched: https://github.com/Lokaltog/powerline-fonts

6. As the plugin YouCompleteMe is using native code (C compiled), you will have to compile the code that has just been cloned. First, make sure you have a valid compiler already installed (gcc recommended). Then, go in the plugin directory:
   `$ cd .vim/bundle/YouCompleteMe/`
   and then execute the shell script 
   `$ ./install.sh`
   Use the flag `--clang-completer` if you want support for C-family languages and `--omnisharp-completer` for C#. The install script will download all the dependencies for you (libclang). (I'm quite unsure about C#, I haven't tested yet.)
   Then follow the YouCompleteMe user guide. Indeed you need to provide compilation flag in order to provide autocompletion for functions/variables defined in your project.

## Add a new plugin

    Edit the vimrc configuration file and add a 
    `Bundle GITHUB_USERNAME/NAME_OF_PROJECT`
    statement and type
    `:BundleInstall` and press return

## Remove an existing plugin

    Edit the vimrc configuration file and remove a 
    `Bundle GITHUB_USERNAME/NAME_OF_PROJECT`
    statement and type
    `:BundleClean` and press return
