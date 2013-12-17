## Installation

 1. First, as some plugins used in this configuration (as Ultisnips) require Python support, make sure your Vim version comes with python support by typing the Vim exec `:version` command and checking if there is `+python` or `+python3` in its output.

    If your Vim does not support python, you will have to either recompile Vim from sources or install the `gvim` package. Indeed, on GNU/Linux distributions the gvim package is typically linked against python (checked on Debian and ArchLinux based distributions).

 2. Clone this repository

        git clone https://github.com/wget/dotvim.git ~/.vim

 3. Create symlinks

        $ ln -s ~/.vim/vimrc ~/.vimrc

 4. Install Vundle, the Vim plugin manager

        $ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

 5. Start Vim, type `:BundleInstall`, press return and wait for all plugin repositories to be cloned.

    OPTIONAL:

 6. As vim-airline is using special symbols, you'll have to patch/replace the font you are using in your terminal emulator. 

    An already patched pack of fonts can be obtained [here](https://github.com/Lokaltog/powerline-fonts).
   
    If you're using ArchLinux or any derivative, install the "[powerline-fonts-git](https://aur.archlinux.org/packages/powerline-fonts-git)" package from [AUR](https://aur.archlinux.org), and choose any font with "for Powerline" in its name in your terminal emulator.

 7. As the plugin YouCompleteMe is using native code (C compiled), you will have to compile the code that has just been cloned.

    First, make sure you have a valid compiler already installed (gcc recommended). Then, go to the plugin directory

        $ cd .vim/bundle/YouCompleteMe/

    and execute the shell script:
    
        $ ./install.sh

    Use the flag `--clang-completer` if you want support for C-family languages; the install script will download the `libclang` dependency for you.

    Use the flag `--omnisharp-completer` for C#. This requires `msbuild`or `xbuild`. Xbuild is provided with `mono` on Linux.

    Then follow the YouCompleteMe user guide. Indeed you need to provide compilation flag in order to provide autocompletion for functions/variables defined in your project.

## Add a new plugin

 Edit the vimrc configuration file, add a statement like this one 

    Bundle GITHUB_USERNAME/NAME_OF_PROJECT

 type  

    :BundleInstall

and press return.

## Remove an existing plugin

 Edit the vimrc configuration file, remove a statement like this one

    Bundle GITHUB_USERNAME/NAME_OF_PROJECT

 type

    :BundleClean

 and press return.
