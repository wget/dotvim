"{{{ README: PREREQUESITES
"-------------------------------------------------------------------------------
" For maximum ease while reading this file in Vim, if sections don't appear 
" please enter this command:
" :set foldmethod=marker
"
" NOTE: Avoid mapping CTRL-TAB keys, it's a little tricky, as the keys are first
" catched by the terminal emulator when Vim is used in CLI.
"}}}

"{{{ General settings
"-------------------------------------------------------------------------------
" Enhance supported features in Vim by dropping Vi compatibility.
" When used for system-wide configuration, the vimrc file will ALWAYS be
" read in 'compatible' mode. This mode will produce some errors in this
" current configuration as unfound features or functions.
" See :help system-vimrc for more details.
set nocompatible

" Disable the modeline usage, preventing such a malicious code to be executed
" see http://lists.alioth.debian.org/pipermail/pkg-vim-maintainers/2007-June/004020.html
" Modeline is a Vim feature allowing to define Vim parameters for a specific
" file at the first or at the last lines of that file.
set modelines=0

" Define the <Leader> key in replacement of the default one \
let mapleader = ","

" Enable the mouse usage in the Vim normal mode
if has("mouse")
    set mouse=n
endif

" Use UTF-8 encoding in file and avoid ^B and stranges characters appearing
" in the statusline when used with vim-powerline plugin.
set encoding=utf-8

" When line wrapping is enabled, move according the screen lines and not
" according to the file lines.
nnoremap j gj
nnoremap k gk

if has("autocmd")
    " Jump to the last position when reopening a file
    augroup lastPosition
        autocmd!
        autocmd BufReadPost * :call <SID>LastFilePosition()
    augroup end
    function! s:LastFilePosition()
        if line("'\"") > 1 && line("'\"") <= line("$")
            execute "normal! g'\""
        endif
    endfunction

    " Enable spell checking only for C, C++ and Tex files
    augroup spellChecking
        autocmd!
        autocmd FileType c,cpp,tex setlocal spell
    augroup end
endif

" Automatically save before commands like :next and :make
"set autowrite

" Hide buffers when they are abandoned, instead of unloading them
"set hidden

" Convert the current word to lowercase in insert mode
inoremap <c-l> <esc>mqviwu`qa

" Convert the current word to UPPERCASE in insert mode
inoremap <c-u> <esc>mqviwU`qa

" Surround a word with "
nnoremap <leader>" mqviw<esc>bi"<esc>ea"<esc>`ql

" Paste from X clipboard
" NOTE: Don't map this key in normal mode: CTRL-V is used for vertical selection
inoremap <silent><c-v> <esc>"+pi

" Copy to X clipboard
inoremap <silent><c-c> <esc>"+yi

" Reselect the text that was just pasted
nnoremap <leader>v V`]

" Save automatically the file when losing focus
augroup saveOnFocusLost
    autocmd!
    autocmd FocusLost * :wa
augroup end
"}}}

"{{{ Plugins management
"-------------------------------------------------------------------------------
" Enable vundle plugin which aims to install plugins and runtime files in their
" own private directories
let systemVimrc = system('vim --version')

if strlen(finddir(fnamemodify($MYVIMRC, ":p:h") . "/.vim/bundle/vundle/"))
    " You got an error when sourced from /etc/vimrc location
    " Solution: Parse the :version output
    "let g:GetVersion = system('vim --version') echo g:GetVersion

    filetype off

    " Add Vundle to the runtimepath
    set runtimepath+=~/.vim/bundle/vundle/
    "runtime bundle/vundle/autoload/vundle.vim

    " If you don't like the directory name `bundle`, you can pass a different
    " name as an argument: call vundle#rc('~/src/vim/bundle')
    call vundle#rc()
    
    " Plugins
    " Mandatory: let's manage vundle by vundle ;-)
    Bundle 'gmarik/vundle'

    " 
    if v:version >= 703 && has("patch584")
        if has("python")

        else
            echoerr "Vim needs to have python support in order for the plugin \"YouCompleteMe\" to work."
        endif
    else
        echoerr "You need at least Vim 7.3.584 in order for the plugin \"YouCompleteMe\" to work."
    endif
    " Bundle from Github
    " Bundle 'tpope/vim-fugitive'
    " Bundle 'Lokaltog/vim-easymotion'
    " Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
    " Bundle 'tpope/vim-rails.git'
    " vim-scripts repos
    " Bundle 'L9'
    " Bundle 'FuzzyFinder'
    " Non github repos example
    "Bundle 'git://git.wincent.com/command-t.git'

    filetype plugin indent on
else
    echoerr "The vundle Vim plugin isn't installed! Please install it with 'git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle'"
endif

" TEMP for dev

runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()
"}}}

"{{{ Appearance
"-------------------------------------------------------------------------------
" Keep at least 3 lines above and below the cursor
set scrolloff=3

" Briefly jump to the matching bracket (only when visible)
"set showmatch

"  FIXME: Add relative number in normal mode and number in insert mode

" Toggle line number to the current buffer (local)
nnoremap <leader>n :call <SID>NumberToggle()<cr>
function! s:NumberToggle()
    if &number
        set nonumber
        echo "Line numbers disabled for \"" . expand("%:p") . "\""
    else
        set number
        echo "Line numbers enabled for \"" . expand("%:p") . "\""
    endif
endfunction

" Toggle relative line number (local)
nnoremap <leader>rn :call <SID>RelativeNumberToggle()<cr>
function! s:RelativeNumberToggle()
    if &relativenumber
        set norelativenumber
        echo "Relative numbers disabled for \"" . expand("%:p") . "\""
    else
        set relativenumber
        echo "Relative numbers enabled for \"" . expand("%:p") . "\""
    endif
endfunction

" Toggle the column which indicates limits of opened and closed folds
nnoremap <silent><leader>f :call <SID>FoldColumnToggle()<cr>
function! s:FoldColumnToggle()
    if &foldcolumn
        setlocal foldcolumn=0
        echo "Fold column deactivated for \"" . @% . "\""
    else
        setlocal foldcolumn=4
        echo "Fold column activated for \"" . @% . "\""
    endif
endfunction

if has("syntax")
    " Enable syntax highlighting
    syntax on

    " Reduce the scope of the syntax highlight, which prevents Vim to hang
    " terribly when syntax highlight is used on very long lines.
    if has("autocmd")
        augroup ReduceHighlightScope
            autocmd!
            autocmd BufReadPost,VimResized * :call <SID>ReduceHighlightScope()
        augroup end

        function! s:GetMaxLength()
            return max(map(range(1, line('$')), "col([v:val, '$'])")) - 1
        endfunction

        function! s:ReduceHighlightScope()
            if s:GetMaxLength() ># &columns
                execute "set synmaxcol=" . &columns
            endif
        endfunction
    endif

    " Set a colorscheme
    try
        let s:definedColorscheme = "jellybeans"
        " let g:molokai_original = 1
        execute "colorscheme " . s:definedColorscheme
    catch /^Vim(\a\+):E185:/
        echo v:throwpoint
        echo 'The colorscheme "' . s:definedColorscheme . '" doesn''t exist, using the default one instead.'
    endtry

    " If using a dark background within the editing area and syntax highlighting
    " turn on this option as well, and forces the colorcheme to be adapted
    " set background=dark

    " Highlight the line where the cursor is currently on
    set cursorline
endif

" Display information into the bottom line
if has("statusline")
    " IMPROVE: Try to detect Powerline plugin as g:powerline_enabled doesn't exist
    " in this namespace
    " FIXME: Doesn't work if system-wide Vim configuration used
    if filereadable(expand("$HOME/.vim/bundle/powerline/plugin/Powerline.vim"))
        " FIXME: Check xterm-256color
        "if &t_Co < 256
            " Explicitly tell Vim we are using a 88/256 color terminal
            set t_Co=256

         "   let g:Powerline_loaded = 0
        "endif

        " Define the symbols and deviders set.
        " Fancy uses custom icons and arrows which requires a patched font.
        let g:Powerline_symbols = 'fancy'
    else
        " Emulate the standard status enabled with command 'set ruler'
        set statusline=%<    " Where to truncate line if too long
        set statusline+=%f   " Path to the buffer file
        set statusline+=\    " Add a space (have to be scaped)
        set statusline+=%h   " Add [help] flag is help file
        set statusline+=%m   " Add [+] (modified) flag is the file has been modified or
                             "     [-] if the file is unmodifiable
        set statusline+=%r   " Add [RO] flag if the file is read only
        set statusline+=%=   " Switch to the right side
        set statusline+=%-14.(%l,%c%V%)
                             " () -> Add a new item group aligned with a 14 right padding
                             " %l -> Line number
                             " %c -> column number
                             " %V -> Vertical column number (assumes tabulations are spaces)
        set statusline+=\ %P " Space with the percentage of displayed file
    endif

    " Always display a status line
    set laststatus=2
endif

" Displays a line at char 80 and colorizes text that goes beyong this value
" FIXME: Only display this line when text goes beyond it.
if has('syntax')
   " set colorcolumn=79
   highlight link OverLength ColorColumn
   "execute 'match OverLength /\%'.&cc.'v.\+/'
endif
" FIXME: Strip all trailing whitespaces in the current file
"nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<cr>:echo 'Trailing whitespaces
"removed for ' . expand("%")<cr>

" Add a completion menu when invoking autocompletion in the Vim cmd line
"set wildmenu

" Show invisible characters
nnoremap <leader><space> :call <SID>ToggleInvisibleCharactersVisibility()<cr>
function! s:ToggleInvisibleCharactersVisibility()
    if &l:list
        set nolist
        echo "Invisible characters have been hidden for \"" . expand("%") . "\""
    else
        set list
        set listchars=tab:▸\ ,eol:¬
        echo "Invisible characters have been shown for \"" . expand("%") . "\""
    endif 
endfunction

" Wrap long line of text, avoiding the wrapping to misbehave when unprintable
" characters are made visible with the 'list' command.
set wrap
set linebreak
set nolist

" Format automatically paragraphs everytime text is inserted or deleted.
set formatoptions+=a
" Only apply reformat on comments to avoid the code to become broken.
set formatoptions+=c
" Don't break a line after a one letter word
set formatoptions+=1
"}}}

"{{{ Autocompletion
"-------------------------------------------------------------------------------
" Add location of the dictionary word completion
if filereadable("/usr/share/dict/words")
    set dictionary+=/usr/share/dict/words
endif

" Disable preview scratch window appearing on completion
set completeopt=menu,menuone,longest

" Set the maximum number of items to be displayed show in the popup menu
if has("insert_expand")
    set pumheight=15
endif
"}}}

"{{{ Indentation
"-------------------------------------------------------------------------------
if has("autocmd")
    " Load indentation rules and plugins according to the detected filetype
    filetype plugin indent on
endif

" Use backspace to remove these kinds of content
set backspace=indent,eol,start

" Specifies the width of a tab character
set tabstop=4
	
" Remove the 4 characters when using backspace. This option prevails when
" expandtab isn't enabled.
" ex.: tabstop = 8
"      softtabstop = 4
"      shiftwidth = 4
"      noexpand
" Using tab and indentation in this configuration will use 4 characters, but
" when pressing tab another time directly, the 4 chars are replaced by a tab
" of 8 chars length. If tabstop equals 4 too, then always tabs will be added.
set softtabstop=4

" Replace tab by spaces
set expandtab

" Use 4 space characters when using automatic indentation (with autoindent) or
" manually with > or < keys.
set shiftwidth=4

" Use the same indent as the previous indented line
set autoindent

" Fold parameters
if has("folding")
    " Add markers folds for Vim and Bash/sh files
    augroup filetype_vim
        autocmd!
        autocmd FileType vim,sh setlocal foldmethod=marker foldlevelstart=0
    augroup end
endif
"}}}

"{{{ Operator pending-mapping
"-------------------------------------------------------------------------------
" NOTE: For mnemonic, the operator abbreviation names are set as "Inside Next
" Parentheses".
" Visually select text around last parentheses
onoremap ip) :<c-u>normal! F)vi(<cr>

" Visually select text around next parentheses
onoremap in( :<c-u>normal! F(vi)<cr>

" Visually select text around last bracket
onoremap ip{ :<c-u>normal! F}vi{<cr>

" Visually select text around next bracket
onoremap in{ :<c-u>normal! F{vi}<cr>
"}}}

"{{{ Search options
"-------------------------------------------------------------------------------
" When searching, this option allows you to jump to the beginning of the file,
" when the end is reached.
set wrapscan

" Ignore the case in search patterns (needed by 'smartcase')
set ignorecase

" Enable case-insensitive search when the search is all-lowercase, but if one
" or more characters is uppercase the search will be case-sensitive.
set smartcase

if has("extra_search")
    " Show the result location when typing a pattern to search. Pressing return
    " goes to the result location while typing Esc to back to the original
    " position.
    set incsearch

    " Briefly jump to the matching bracket is it it visible on the same screen
    set showmatch

    " Toggle the search highlight feature. When you get bored looking at the
    " highlighted matches, toggle the search highlight feature off. This does
    " not change the option value, as soon as you use a search command,
    " the highlighting comes back.
    set hlsearch
    nnoremap <leader>/ :call <SID>HlsearchToggle()<cr>
    function! s:HlsearchToggle()
        if &l:hlsearch
            set nohlsearch
            echo "Highlighted matches deactivated."
        else
            set hlsearch
            echo "Previous matches highlighted."
        endif
    endfunction
endif

" Use <tab> instead of % in order to key match brackets pairs
nnoremap <tab> %
vnoremap <tab> %

" Opens help vertically
noremap <leader><F1> :vertical rightbelow help<cr>

" Get ready to look for an item in help
nnoremap <F1> :help 

" Search for text in the whole help
nnoremap <leader>g<F1> :helpgrep 

" Get rid of crappy regex Vim handling and use normal regexes instead
nnoremap / /\v
vnoremap / /\v

" Highlight the trailing whitespaces as an error
nnoremap <silent><leader>w :match Error /\v $/<cr> :echo "Trailing whitespaces marked as error."<cr>
nnoremap <silent><leader>W :match none<cr>

" Next occurrence when using :helpgrep
nnoremap <silent><c-n> :cn<cr>

" Use grep to search for the current word under the cursor 
nnoremap <leader>g :silent execute 'grep! -R ' . shellescape(expand("<cword>")) . ' .'<cr>:copen<cr>:redraw!<cr>
nnoremap <leader>G :call GrepOperator("up")<cr>
function! GrepOperator(...)
    let word = "shellescape(expand(\"<cword>\"))"
    if a:000[0] ==# "up"
        let l:word = "shellescape(expand("<cWORD>"))"
    echom word
    endif
    execute 'grep! -R ' . word . ' .'
    redraw!
    copen
endfunction
" }}}

"{{{ Sessions management
"-------------------------------------------------------------------------------
" The following functions will save your settings (see :help :mksession) on Vim
" exit, and load those settings when you enter Vim again from the same folder.

" Check if the needed Vim features are present and define session files and
" paths names again as buffer variables are wiped out when restoring a vim
" session
function! s:DefineSessionPath()
    if !has("mksession")
        echoerr "Vim wasn't compiled with +mksession feature: Vim sessions not supported."'
    elseif !has("file_in_path")
        echoerr "Vim wasn't compiled with +find_in_path feature: Vim sessions are supported only manually with :mksession command, but not with the shortcuts defined in this vimrc."'
    else
        let b:sessionDefaultDir = $HOME . "/.vim/sessions"
        let b:sessionDir = b:sessionDefaultDir . getcwd()
        let b:sessionFile = b:sessionDir . "/session.vim"
        return 1
    endif
endfunction

" Creates a session
nnoremap <silent><leader>ms :call <SID>MakeSession()<cr>
function! s:MakeSession()
    if !<SID>DefineSessionPath()
        return
    endif

    " Hereafter we have to use strlen() as finddir and findfile functions
    " return the path or file found.
    " If the directory doesn't already exists, create it
    if !strlen(findfile(b:sessionDir))
        call mkdir(b:sessionDir, "p")
        redraw
    else " The firectory already exists as a file
        echoerr "The directory " . b:sessionFile . " can't have the same name as the file \"" . b:sessionFile . "\" used to save your Vim session!\nPLease rename your folder or manually use :mksession.\n"
        return 0
    endif

    " Now we are sure the directory is created, check if we can write to it
    if filewritable(b:sessionDir) != 2
        echoerr "The session directory \"" . b:sessionDir . "\" is not writable, please fix file permissions!\nUnable to create your session file.\n"
        return 0
    endif

    " Check if the session file isn't a directory
    if strlen(finddir(b:sessionFile))
        echoerr "The session \"" . b:sessionFile . "\" is already a directory: please remove it."
        return 0
    endif

    " If the session file already exists
    if strlen(findfile(b:sessionFile))

        " The session file is writable
        if filewritable(b:sessionFile)
            execute "mksession! " . b:sessionFile
            echo "The session \"" . b:sessionFile . "\" has been updated."

        else " The session file isn't writable
            echoerr "The session \""  b:sessionFile  "\" already exists but can''t be written.\nPlease check your the write persissions for this file (see umask)."
            return 0
        endif
    " If the session file doesn't exist, create it
    else 
        " Prevent the global variable to be saved in the session file
        if exists("g:sessionLoaded")
            unlet g:sessionLoaded 
        endif
        execute "mksession! " . b:sessionFile
        echo "The session \"" . b:sessionFile . "\" has been created"
        " Recreate the variable as we are using a Vim session
        let g:sessionLoaded = 1
    endif

    " The session file has been successfully created, but isn't readable
    if !filereadable(b:sessionFile)
        echohl WarningMsg
        echo "but you won't be able to read it back in Vim as the file isn't readable. Please check your file permissions (see umask)."
        echohl None
    else
        echon "."
    endif
endfunction

" On Vim exit, if a session is currently used, ask the user if he wants to
" update it. 
" NOTE: Don't automatically update the session on Vim exit, otherwise the
" project session from current directory will be replaced with the current
" opened file(s). This behavior is unwanted.
if has("autocmd")
    " Update session when leaving Vim
    augroup UpdateSession
        autocmd!
"        autocmd VimLeave * :call <SID>UpdateSession()<cr>
    augroup end
endif
function! s:UpdateSession()
    if !<SID>DefineSessionPath()
        return
    endif
    if strlen(findfile(b:sessionFile))
        if exists("g:sessionLoaded")
            let l:choice = 1
            while l:choice != 1
                echohl ErrorMsg
                let l:choice = confirm("You are using a session for this directory.\nDo you want to update it with the current one?", "&Yes\n&No", 1)
                echohl None
                if choice == 1
                    wall " Saves all modifications
                    call <SID>MakeSession()
                else
                    let l:choice = confirm("Are you sure you want to leave without saving changes?", "&Yes\n&No", 2)
                    if l:choice == 1
                        let l:choice = 0
                    endif
                endif
            endwhile
        endif
    endif
endfunction
" Quit all buffers and exit Vim
nnoremap <silent>SQ :call <SID>UpdateSession()<bar>:qall<cr>

" Loads a session if it exists
nnoremap <silent><leader>ls :call <SID>LoadSession()<cr>
function! s:LoadSession()
    if !<SID>DefineSessionPath()
        return
    endif

    " Session file exists
    if strlen(findfile(b:sessionFile))
        " Session file readable
        if filereadable(b:sessionFile)
            execute 'source ' . b:sessionFile
            redraw!
            echo "The session for the directory \"" . getcwd() . "\" has been reloaded."
            let g:sessionLoaded = 1
        " Session file not readable
        else 
            echohl ErrorMsg
            echo "The session \"" . b:sessionFile . "\" isn''t readable.\nPlease check your file permissions (see umask)."
            echohl None
        endif
    " Session file doesn't exist
    else 
        echohl ErrorMsg
        echo "There is no session for the directory \"" . getcwd() . "\""
        echohl None
    endif
endfunction
"if has("autocmd")
    " NOTE: Load automatically latest vim session can cause some problems when
    " the file doesn't exist anymore (e.g. when edited in /tmp), especially
    " after having used 'crontab -e'
"   augroup LoadSession
"      autocmd VimEnter * nested :call LoadSession()
"   augroup end
"endif

" Removes a session
nnoremap <silent><leader>rs :call <SID>RemoveSession()<cr>
function! s:RemoveSession()
    if !<SID>DefineSessionPath()
        return
    endif
    if strlen(findfile(b:sessionFile))
        " Remove the session file
        execute 'silent! !rm -rf ' . b:sessionFile
        redraw!
        " Remove the directory structure if it is empty
        " NOTE: If the directory is not readable or not writable, it won't be removed
        execute 'silent !find "' . b:sessionDefaultDir . '" -type d -empty -delete 2>/dev/null'
        redraw!
        echo "The session \"" . b:sessionFile . "\" has been removed."
    endif
endfunction

" FIXME: The following functions will load any files passed as arguments to Vim and
" manage them in different viewports
"if has("autocmd")
"    augroup OpenArgsInFiles
"        autocmd!
"        "autocmd VimEnter * :call <SID>OpenArgsInFiles()
"    augroup end
"endif
"function! s:OpenArgsInFiles()
"    let l:i = 0
"    if argc() > 1
"        while l:i < argc()
"            execute 'vsplit ' . argv(l:i)
"            let l:i += 1
"        endwhile
"    endif
"    echom l:i
"endfunction
"}}}

"{{{ Sourcing mappings
"-------------------------------------------------------------------------------
" Source a local configuration file if available
if filereadable("/etc/vim/vimrc.local")
    source /etc/vim/vimrc.local
endif

" Edit directly personal vimrc without losing concentration
" Pay attention, the $MYVIMRC env variable is only set when a vimrc filetype is found.
if strlen($MYVIMRC) != 0
    nnoremap <silent><leader>ev :tabnew $MYVIMRC<cr>:echo $MYVIMRC . ' has been loaded in a new tab.'<cr>
    nnoremap <silent><leader>sv :silent :source $MYVIMRC<cr>:echo $MYVIMRC . " has been sourced"<cr>
else
    nnoremap <silent><leader>ev :echohl ErrorMsg<cr>:echo ".vimrc file not found"<cr>:echohl None<cr>
    nnoremap <silent><leader>sv :echohl ErrorMsg<cr>:echo ".vimrc file not found"<cr>:echohl None<cr>
endif

" Source current file
nnoremap <silent><leader>s :source %<cr>:execute 'echo "\"' . expand("%:p") . '\" sourced"'<cr>
"}}}

"{{{ Tabs management
"-------------------------------------------------------------------------------
" Map a key to select directly the numbered tab
map <C-t> :tabnew <cr>
map <S-w> :tabclose <cr>

" Next tab
noremap <S-h> gT
noremap <C-PageUp> gT

" Previous tab
noremap <S-l> gt
noremap <C-PageDown> gt
"}}}

"{{{ Window management
"-------------------------------------------------------------------------------
" Increase window size
nnoremap w+ <C-W>>
" Decrease window size
nnoremap w- <C-W><
"}}}
" vim: set foldmethod=marker foldlevel=0:
