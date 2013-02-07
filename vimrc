"-------------------------------------------------------------------------------
" README: PREREQUESITES {{{
" For maximum ease while reading this file, please enter this command:
" :set foldmethod=marker
"
" NOTE: Avoid mapping CTRL-TAB keys, it's a little tricky, as the keys are first
" catched by the terminal emulator
"}}}

"-------------------------------------------------------------------------------
" General settings {{{
" Enhance supported features in Vim by dropping Vi compatibility.
" When used for system-wide configuration, the vimrc file will ALWAYS be
" read in 'compatible' mode. This mode will produce some errors in this
" current configuration as unfound features or functions.
" See :help system-vimrc for more details.
set nocompatible

" Enable pathogen plugin which aims to install plugins and runtime files in their
" own private directories
if filereadable(expand("$HOME/.vim/bundle/pathogen/autoload/pathogen.vim"))
    " Avoid symlink usage in ~/.vim/autoload/pathogen.vim
    " to stick pathoge as a submodule
    runtime bundle/pathogen/autoload/pathogen.vim

    " Add ~/.vim/bundle to the runtimepath
    " If you don't like the directory name `bundle`, you can pass a different
    " name as an argument: call pathogen#infect('~/src/vim/bundle')
    call pathogen#infect()

    " Regenerate tags for all help files located in the new bundle repository
    Helptags
endif

" Define the <Leader> key in replacement of the default one \
let mapleader = ","

" Enable the mouse usage in the Vim normal mode
if has("mouse")
    set mouse=n
endif

" Change encoding to avoid ^B and stranges characters appearing in the
" statusline when used with vim-powerline plugin
set encoding=utf-8

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

" Hide buffers when they are abandoned
"set hidden

" Briefly jump to the matching bracket (only when visible)
"set showmatch

" Toggle line number to the current buffer
nnoremap <leader>n :call <SID>NumberToggle()<cr>
function! s:NumberToggle()
    if &number
        setlocal nonumber
        echo "Line numbers disabled for \"" . expand("%:p") . "\""
    else
        setlocal number
        echo "Line numbers enabled for \"" . expand("%:p") . "\""
    endif
endfunction

" Toggle relative line number to the current buffer
nnoremap <leader>rn :call <SID>RelativeNumberToggle()<cr>
function! s:RelativeNumberToggle()
    if &relativenumber
        setlocal norelativenumber
        echo "Relative numbers disabled for \"" . expand("%:p") . "\""
    else
        setlocal relativenumber
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

" Convert the current word to lowercase in insert mode
inoremap <c-l> <esc>mqviwu`qa

" Convert the current word to UPPERCASE in insert mode
inoremap <c-u> <esc>mqviwU`qa

" Surround a word with <">
nnoremap <leader>" mqviw<esc>bi"<esc>ea"<esc>`ql

" Paste from X clipboard
" NOTE: Don't map this key in normal mode: CTRL-V is used for vertical selection
inoremap <silent><c-v> <esc>"+pi
" Copy to X clipboard
inoremap <silent><c-c> <esc>"+yi
"}}}

"-------------------------------------------------------------------------------
" Appearance {{{
" Enable the use of grouping markers in vim (default {{{ and }}})
if has("syntax")
    " Enables syntax highlighting
    syntax on

    " Set a colorscheme if it exists
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
"    set background=dark

    " Highlight the line where the cursor is currently on
    set cursorline

    " Reduces the scope of the syntax highlight, which prevents Vim to hang
    " terribly when syntax highlight is used on very long lines.
    if has("autocmd")
        augroup ReduceHighlishtScope
            autocmd!
            autocmd BufReadPost,VimResized * :call <SID>ReduceHighlishtScope()
        augroup end

        function! s:GetMaxLength()
            return max(map(range(1, line('$')), "col([v:val, '$'])")) - 1
        endfunction

        function! s:ReduceHighlishtScope()
            if s:GetMaxLength() ># &columns
                execute "set synmaxcol=" . &columns
            endif
        endfunction
    endif
endif

" Display information in the bottom line
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

    " Always displays a status line
    set laststatus=2
endif

" Show (partial) command in statusline
if has("cmdline_info")
    "set showcmd
endif

" Displays a line at char 80 and colorizes text that goes beyong this value
"if exists('+colorcolumn')
"    set colorcolumn=79
"    highlight link OverLength ColorColumn
"    exec 'match OverLength /\%'.&cc.'v.\+/'
"endif
"}}}

"-------------------------------------------------------------------------------
" Autocompletion {{{
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

" 
if v:version >= 703 && has("patch584")
    if has("python")

    else
        echohl ErrorMsg
        echom "Vim needs to have python support in order for the plugin \"YouCompleteMe\" to work."
        echoHl None
    endif
else
    echohl ErrorMsg
    echom "You need at least Vim 7.3.584 in order for the plugin \"YouCompleteMe\" to work."
    echoHl None
endif


"}}}

"-------------------------------------------------------------------------------
" Indentation {{{
if has("autocmd")
    " Load indentation rules and plugins according to the detected filetype
    filetype plugin indent on
endif

" Use backspace to remove content
set backspace=indent,eol,start
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

if has("folding")
    augroup filetype_vim
        autocmd!
        autocmd FileType vim,sh setlocal foldmethod=marker foldlevelstart=0
    augroup end
endif
"}}}

"-------------------------------------------------------------------------------
" Operator pending-mapping {{{
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

" Next email address
" TODO: It's still failed, f**** regex
"onoremap in@ :<c-u>normal! /([a-zA-Z0-9]+[-_.]*)+@([a-zA-Z0-9]+[-_.]?)+.[a-z]{2,}<cr>
"}}}

"-------------------------------------------------------------------------------
" Search options {{{
" Opens help vertically
noremap <leader><F1> :vertical rightbelow help<cr>

" Get ready to look for an item in help
nnoremap <F1> :help 

" Search for text in the whole help
nnoremap <leader>g<F1> :helpgrep 

" Get ready to get input from an unescaped search when using regex
nnoremap / /\v
nnoremap <silent><c-f> /\v

" When searching, this option allows you to jump to the beginning of the file,
" when the end is reached.
set wrapscan

" Ignore the case in search patterns
"set ignorecase

" When searching, override the 'ignorecase' option if
" the search pattern contains uppercase characters
set smartcase

if has("extra_search")
    " Highlight all matching when performing a search
    setlocal hlsearch
    " Highlight the next match while typing the search pattern
    setlocal incsearch
endif

" Stop highlighting after having successful search
if has("extra_search")
    nnoremap <leader>/ :call <SID>HlsearchToggle()<cr>
    function! s:HlsearchToggle()
        if &l:hlsearch
            " FIXME: hlsearch is a global boolean, no way to set it to local
            setlocal nohlsearch
            echo "Highlighted matches deactivated for \"" . expand("%:p") . "\""
        else
            setlocal hlsearch
            echo "Highlighted matches activated for \"" . expand("%:p") . "\""
        endif
    endfunction

endif

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

"-------------------------------------------------------------------------------
" Sessions management {{{
" The following functions will save your settings (see :help :mksession) on Vim
" exit, and load those settings when you enter Vim again from the same folder.

" Check if the needed Vim features are present and define session files and
" paths names again as buffer variables are wiped out when restoring a vim
" session
function! s:DefineSessionPath()
    if !has("mksession")
        echohl ErrorMsg 
        if !has("file_in_path")
            echo "Vim wasn''t compiled with +mksession and +find_in_path features: Vim sessions not supported."'
        else
            echo "Vim wasn''t compiled with +mksession feature: Vim sessions not supported."'
        endif
        echohl None
    else
        if !has("file_in_path")
            echohl ErrorMsg
            echo "Vim wasn''t compiled with +find_in_path feature: Vim sessions are supported only manually with :mksession command, but not with the shortcuts defined in this vimrc."'
            echohl None
        else
            let b:sessionDefaultDir = $HOME . "/.vim/sessions"
            let b:sessionDir = b:sessionDefaultDir . getcwd()
            let b:sessionFile = b:sessionDir . "/session.vim"
            return 1
        endif
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
        execute 'silent !mkdir -p ' . b:sessionDir
        redraw!
    else " The firectory already exists as a file
        execute 'echohl ErrorMsg | echo "The directory \"' . b:sessionFile . '\" can''t have the same name as the file \"' . b:sessionFile . \"' used to save your Vim session!\nPLease rename your folder or manually use :mksession.\n" | echohl None'
        return
    endif

    " Now we are sure the directory is created, check if we can write to it
    if filewritable(b:sessionDir) != 2
        execute 'echohl ErrorMsg | echo "The session directory \"' . b:sessionDir . '\" is not writable, please fix file permissions!\nUnable to create your session file.\n" | echohl None'
        return
    endif

    " Check if the session file isn't a directory
    if strlen(finddir(b:sessionFile))
        execute 'echohl ErrorMsg | echo "The session \"' . b:sessionFile . '\" is already a directory: please remove it." | echohl None'
        return
    endif

    " If the session file already exists
    if strlen(findfile(b:sessionFile))

        " The session file is writable
        if filewritable(b:sessionFile)
            execute "mksession! " . b:sessionFile
            execute 'echo "The session \"' . b:sessionFile . '\" has been updated."'

        else " The session file isn't writable
            execute 'echohl ErrorMsg | echo "The session \"' . b:sessionFile . '\" already exists but can''t be written.\nPlease check your the write persissions for this file (see umask)." | echohl None'
            return
        endif

    else " If the session file doesn't exist, create it
        " Prevent the global variable to be saved in the session file
        if exists("g:sessionLoaded")
            unlet g:sessionLoaded 
        endif
        execute "mksession! " . b:sessionFile
        execute 'echo "The session \"' . b:sessionFile . '\" has been created."'
        " Recreate the variable as we are using a Vim session
        let g:sessionLoaded = 1
    endif

    " The session file has been successfully created, but isn't readable
    if !filereadable(b:sessionFile)
        execute 'echohl WarningMsg | echo "but you won''t be able to read it back in Vim as the file isn''t readable. Please check your file permissions (see umask)." | echohl None'
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
            let updateChoice = 1
            let l:displayCarriageReturn = 0
            while updateChoice !=# "yes" && updateChoice !=# "no"
                if l:displayCarriageReturn == 1
                    echo "\n"
                endif
                echohl ErrorMsg
                let updateChoice = input("You are using a session for this directory.\nDo you want to update it with the current one? [(Y)es | (N)o] ", "no")
                echohl None
                if updateChoice == "yes"
                    wall " Saves all modifications
                    call <SID>MakeSession()
                endif
               let l:displayCarriageReturn = 1
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
            execute 'echo "The session for the directory \"' . getcwd() . '\" has been reloaded."'
            let g:sessionLoaded = 1
        else " Session file not readable
            execute 'echohl ErrorMsg | echo "The session \"' . b:sessionFile . '\" isn''t readable.\nPlease check your file permissions (see umask)." | echohl None'
        endif
    else " Session file doesn't exist
        execute 'echohl ErrorMsg | echo "There is no session for the directory \"' . getcwd() . '\"" | echohl None'
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
        execute 'echo "The session \"' . b:sessionFile . '\" has been removed."'
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

"-------------------------------------------------------------------------------
" Sourcing mappings {{{
" Source a local configuration file if available
if filereadable("/etc/vim/vimrc.local")
    source /etc/vim/vimrc.local
endif

" Edit directly personal vimrc without losing concentration
" Pay attention, the $MYVIMRC env variable is only set when a vimrc filetype is found.
if strlen($MYVIMRC) != 0
    nnoremap <silent><leader>ev :tabnew $MYVIMRC<cr>:echo $MYVIMRC . ' has been loaded in a new tab.'<cr>
    nnoremap <silent><leader>sv :silent :source $MYVIMRC<cr>:echo $MYVIMRC . " has been loaded"<cr>
else
    nnoremap <silent><leader>ev :echohl ErrorMsg<cr>:echo ".vimrc file not found"<cr>:echohl None<cr>
    nnoremap <silent><leader>sv :echohl ErrorMsg<cr>:echo ".vimrc file not found"<cr>:echohl None<cr>
endif

" Source current file
nnoremap <silent><leader>s :source %<cr>:execute 'echo "\"' . expand("%:p") . '\" sourced"'<cr>
"}}}

"-------------------------------------------------------------------------------
" Tabs management {{{
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

"-------------------------------------------------------------------------------
" Window management {{{
" Increase window size
nnoremap w+ <C-W>>
" Decrease window size
nnoremap w- <C-W><
"}}}
