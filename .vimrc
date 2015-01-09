" Vim support file to switch on loading indent files for file types
" Filename:      vimrc
" Description:   Vim configuration file
" Maintainer:    Mehernosh Mohta <mmohta@vision6.com.au>
" Last Modified: 02 August 2013

set nocompatible        " Use Vim defaults (much better!)
set nu

" Highlighting
syntax on  " Enable syntax highlighting

" We need to set the line endings dos as default
if has("unix")
    "set fileformats=unix,dos,mac
    set fileformats=dos,unix,mac
elseif has("win32") || has("win64")
    set fileformats=dos,unix,mac
elseif has("mac")
    set fileformats=dos,unix,mac
    "set fileformats=mac,unix,dos
endif

set background=dark  " Tell the colorscheme that I prefer dark colors
set t_Co=256
"colorscheme koehler
"colorscheme inkpot
colorscheme molokai
"colorscheme badwolf

" Trim spaces from the end
autocmd BufWritePre * :%s/\s\+$//e

" Automatically create php headers only while a new file is created.
if has("autocmd")
    let year = strftime("%Y")

    augroup content
        autocmd BufNewFile *.php
        \ 0put = '<?php' |
        \ 1put = '//' |
        \ 2put = '// +----------------------------------------------------------------------+' |
        \ 3put = '// \| Vision 6 - '              .     expand('%:t<afile>')           .'    \|' |
        \ 4put = '// +----------------------------------------------------------------------+' |
        \ 5put = '// \| Put your description here                                            \|' |
        \ 6put = '// +----------------------------------------------------------------------+' |
        \ 7put = '// \| Copyright (c) ' . year . '   Vision 6 Pty Ltd.                       \|' |
        \ 8put = '// +----------------------------------------------------------------------+' |
        \ 9put = '// \| Authors: Mehernosh Mohta <mmohta@vision6.com.au>                     \|' |
        \ 10put = '// +----------------------------------------------------------------------+' |
        \ 11put = '//' |
        \ 12put = '//' |
        "\ 12put = '// $Id$' |
        \ $put = '' |
        \ $put = '' |
        \ $put = '?>' |
        \ norm gg19jf]
    augroup END
endif

augroup misc
    autocmd!
    " When opening a file, go to the last position
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
                \| exe "normal! g'\"" | endif
augroup end

" Editing prefrences
set shiftwidth=4                " Number of spaces for each indent
set softtabstop=4               " Number of spaces for tab key
set tabstop=4
set autoindent                  " If you are indented and start a new line, this makes the new line indented, too:
set smartindent                " This it makes some sort of autoindenting occur, like when you have an open { at the end of a line.  I'm not sure I love this, so it might not last long
set cindent
set smarttab                    " Smart handling of the tab key
set expandtab                   " Use spaces for tabs
set shiftround                  " Round indent to multiple of shiftwidth

set backspace=indent,eol,start  " Allow backspacing over these
set list                        " show empty space at the end
set listchars=tab:\|_,trail:-,eol:$   " show tabs and trailing
silent! set listchars+=nbsp:~   " show no-break space as tilde if supported

"noremap <silent> <Esc> :silent noh<Bar>echo<CR>

" trim white spaces while saving files
nmap s <Esc>:0,$s/\s+\$//gi <CR>

" convert tabs to white space
nmap t <Esc>:0,$s/[\t]\+/    /gi <CR>

" map j to gj and k to gk, so line navigation ignores line wrap
map j gj
map k gk

" Disable the arrow keys.
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
imap <up> <nop>
imap <down> <nop>
imap <left> <nop>
imap <right> <nop>

set showcmd       " Display the command in the last line
set showmode      " Display the current mode in the last line
set ruler         " Display info on current position
set laststatus=2  " Always show status line

" Spaces are to be included with a forward slash \<space>
set statusline=  " Defines the content of the statusline
set stl+=%(%5*[%n]%*\ %)                         " Buffer number
set stl+=%(%<%4*%f%*\ %)                         " Filename
set stl+=%(%7*%m%*\ %)                           " Modified flag
set stl+=%(%3*%r%*\ %)                           " Readonly flag
set stl+=%(%3*%w%*\ %)                           " Preview flag
set stl+=%(%9*[%{&ff}]%*\ %)                     " File format
set stl+=%(%9*[%{(&fenc!=''?&fenc:&enc)}]%*\ %)  " File encoding
set stl+=%(%6*%y%*\ %)                           " File type
set stl+=[%6*CWD:%r%{getcwd()}%h]                 " Get Current working dir
"set stl+=%(%1*%#error#[PHP:%{exists('b:php_status')\ ?\ b:php_status\ :\ 'No\ Error'}%h]%*\ %)               " Get Php errors
set stl+=%(%1*[PHP:%#error#%{ParsePhp()}%h]%*\ %)               " Get Php errors
" set stl+=%(%1*[%{GetFunctionDef()}%h]%*\ %)               " Get Php errors
"set stl+=%(%1*[{Tlist_Get_Tagname_By_Line()}%h]%*\ %)
set stl+=%=                                      " Left/right separator
set stl+=%(%1*[Debug:%#error#%{CheckDebug()}%h]%*\ %)               " Get Php errors
set stl+=%(%3*[TrailComma:%#error#%{TrailCommaJS()}%h]%*\ %)               " Get Trailing Comma in js
set stl+=%(%9*[%{strftime('%d/%m/%y\ -\ %H:%M')}]%*\ %) "Show time
set stl+=%(%1*[%o]%*\ %)                         " Byte number
set stl+=%(%1*+%{indent('.')/&sw}%*\ %)          " Indent level
set stl+=%(%1*%l,%c%V/%L%*\ %)                   " Position line,column/total
set stl+=%(%3*%P%*%)                             " Percentage through file

function! TrailCommaJS()
    let l:fType = &filetype
    if fType == 'javascript'
        redir => trail_message
        silent! execute 'match Error /,\_s*[)}]/'
        redir END
        return trail_message
    else
        return 'No'
    endif
endfunction

function! CheckDebug()
    let l:fType = &filetype
    if fType == 'php' || fType == 'javascript'
        let file = expand('%')
        if filereadable(file)
            let l:output = system('php ' . $HOME . '/bin/check_debug.php ' . file)
            if strlen(output) > 0
                return output
            else
                return 'False'
            endif
        endif
    else
        return 'False'
    endif
endfunction

function! ParsePhp()
    let l:fType = &filetype
    if fType == 'php'
        let file = expand('%')
        if filereadable(file)
            let l:output = system('php -l ' . file)
            if !v:shell_error
                return 'No Error'
            endif
            if strlen(output) > 0
                if version >= 700
                    " return the actual php error
                    let message = split(output, "\n")
                    return message[2]
                else
                    return 'Error'
                endif
            endif
        endif
    endif
    return 'Not a PHP script'
endfunction

" get all variables aligned in one straight line
noremap <silent> =  :call MyAlign('=')<Cr>
noremap <silent> ,> :call MyAlign('=>')<Cr>

function! MyAlign(char)
    let l:start = line('.')
    let l:end   = search("^$") - 1 " search for a new line
    if (start < end)
        " When search is not found it automatically travels on the top
        " thus gives range error
        exec start.','.end.'Align' . a:char
    endif
endfunction

command! -nargs=? -range Align <line1>,<line2>call AlignSection('<args>')
vnoremap <silent> <Leader>a :Align<CR>

function! AlignSection(regex) range
    let extra   = 1
    let sep     = empty(a:regex) ? '=' : a:regex
    let maxpos  = 0
    let section = getline(a:firstline, a:lastline)

    for line in section
        let pos = match(line, ' *'.sep)
        if maxpos < pos
            let maxpos = pos
        endif
    endfor
    call map(section, 'AlignLine(v:val, sep, maxpos, extra)')
    call setline(a:firstline, section)
endfunction

function! AlignLine(line, sep, maxpos, extra)
    let m = matchlist(a:line, '\(.\{-}\) \{-}\('.a:sep.'.*\)')
    if empty(m)
        return a:line
    endif
    let spaces = repeat(' ', a:maxpos - strlen(m[1]) + a:extra)
    return m[1] . spaces . m[2]
endfunction
"set ttyfast

set lazyredraw
set cursorline  "highlight current line

" Folding
set foldenable
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max
"nnoremap <space> za     " space open/closes folds
set foldmethod=indent   " fold based on indent level
"set foldlevel=0
"set modelines=1

" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

"let g:nerdtree_tabs_open_on_console_startup=1

"Becomes handy when u using buffers$
"set mouse=a$

" => Minibuffer plugin$
"""""""""""""""""""""""""""""""
let g:miniBufExplModSelTarget = 1
let g:miniBufExplModSelTarget    = 0
let g:miniBufExplUseSingleClick  = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplVSplit          = 25
let g:miniBufExplSplitBelow      = 0
let g:bufExplorerSortBy          = "name"
let g:miniBufExplorerMoreThanOne = 0

"for buffers that have NOT CHANGED and are NOT VISIBLE.
" highlight MBENormal guifg=LightBlue
"
"for buffers that HAVE CHANGED and are NOT VISIBLE
" highlight MBEChanged guifg=Red
"
" buffers that have NOT CHANGED and are VISIBLE
" highlight MBEVisibleNormal term=bold cterm=bold gui=bold guifg=Green
"
" buffers that have CHANGED and are VISIBLE
" highlight MBEVisibleChanged term=bold cterm=bold gui=bold guifg=Green
"
" autocmd BufRead,BufNew :call UMiniBufExplorer
" map <leader>u :TMiniBufExplorer<cr>:TMiniBufExplorer<cr>
"
" use mice while navigating buffers.
" single clicks on left can be easy to switch them
"if has("mouse")
"    set mouse=a
"    map <MouseDown> <C-Y>
"    map <S-MouseDown> <C-U>
"    map <MouseUp> <C-E>
"    map <S-MouseUp> <C-D>
"    set ttymouse=xterm2
"    set mousemodel=extend
"endif
"
function! Find(name)
    let l:list=system("find . -name '".a:name."' | grep -v \".git/\" | perl -ne 'print \"$.\\t$_\"'")
    let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
    if l:num < 1
        echo "'".a:name."' not found"
        return
    endif
    if l:num != 1
        echo l:list
        let l:input=input("Which ? (CR=nothing)\n")
        if strlen(l:input)==0
            return
        endif
        if strlen(substitute(l:input, "[0-9]", "", "g"))>0
            echo "Not a number"
            return
        endif
        if l:input<1 || l:input>l:num
            echo "Out of range"
            return
        endif
        let l:line=matchstr("\n".l:list, "\n".l:input."\t[^\n]*")
    else
        let l:line=l:list
    endif
    let l:line=substitute(l:line, "^[^\t]*\t./", "", "")
    execute ":e ".l:line
endfunction
command! -nargs=1 Find :call Find("<args>")

" look for :TODO: messages
"augroup CheckTODO
"autocmd!
"autocmd BufWritePost,BufRead *.php,*.css,*.js call CheckTODO()
"augroup end

function! CheckTODO()
    if version >= 700
        let l:todos = []

        let l:pos = getpos('.')
        try
            silent global/:TODO:/call add(l:todos, line('.'))
        finally
            " restore cursor position
            call setpos('.', l:pos)
        endtry

        if len(l:todos) == 1
            let l:todo_warning = ':TODO: comment on line ' . l:todos[0]
        elseif len(l:todos)
            let l:todo_warning = ':TODO: ' . len(l:todos) . ' comments on lines ' . join(l:todos, ', ')
        else
            let l:todo_warning = ''
        endif

        if strlen(l:todo_warning)
            redraw!
            echohl Error
            echo l:todo_warning
            echohl None
        endif
    endif
endfunction

command! CheckTODO :call CheckTODO()

"set undodir=~/.vim/undodir
"set undofile
"set undolevels=1000
"set undoreload=10000
"
inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-P> :call PhpDocSingle()<CR>
vnoremap <C-P> :call PhpDocRange()<CR>
