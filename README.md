## Installation

1. Clone this repository

        git clone https://github.com/wget/dotvim.git ~/.vim

2. Create symlinks

        $ ln -s ~/.vim/vimrc ~/.vimrc

3. Install Vundle, the Vim plugin manager

        $ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

4. Start Vim, type `:BundleInstall`, press return and wait for all plugin repositories to be cloned.

    OPTIONAL:

5. As vim-airline is using special symbols, you'll have to patch/replace the font you are using in your terminal emulator. 

   An already patched pack of fonts can be obtained [here](https://github.com/Lokaltog/powerline-fonts).
   
   If you're using ArchLinux or any derivative, install the "[powerline-fonts-git](https://aur.archlinux.org/packages/powerline-fonts-git)" package from [AUR](https://aur.archlinux.org), and choose any font with "for Powerline" in its name in your terminal emulator.

6. As the plugin YouCompleteMe is using native code (C compiled), you will have to compile the code that has just been cloned.

   First, make sure you have a valid compiler already installed (gcc recommended). Then, go to the plugin directory

        $ cd .vim/bundle/YouCompleteMe/

   then execute the shell script
    
        $ ./install.sh

   Use the flag `--clang-completer` if you want support for C-family languages and `--omnisharp-completer` for C#. The install script will download all the dependencies for you (libclang). (I'm quite unsure about C#, I haven't tested yet.)

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
