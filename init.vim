"=============================================================================
" dark_powered.vim --- Dark powered mode of SpaceVim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


" SpaceVim Options: {{{
let g:spacevim_enable_debug = 1
let g:spacevim_realtime_leader_guide = 1
let g:spacevim_enable_tabline_filetype_icon = 1
let g:spacevim_enable_statusline_display_mode = 0
let g:spacevim_enable_os_fileformat_icon = 1
let g:spacevim_buffer_index_type = 1
let g:spacevim_enable_vimfiler_welcome = 1
let g:spacevim_enable_debug = 1
" }}}

" SpaceVim Layers: {{{
" }}}



" Hex edit
command XXD %!xxd

" Set paste
set pastetoggle=<F2>
" command P set paste
" command NP set nopaste

" Remove trailing whitespaces
command T %s/\s\+$//e


" Auto format C code using indent
au BufWritePost *.c :silent! execute "!indent -linux %" | redraw!
au BufWritePost *.ino :silent! execute "!indent -linux %" | redraw!

" Auto format Python code using autopep8
au BufWritePost *.py :silent! execute "!autopep8 --in-place --aggressive --aggressive %" | redraw!

" Auto format Lua code using luaformatter
au BufWritePost *.lua :silent! execute "!/home/jm33/.luarocks/bin/luaformatter -a -s 4 %" | redraw!

" Code style
let g:spacevim_default_indent = 4
let g:spacevim_max_column     = 120

" If you want to add some custom plugins, use these options:
let g:spacevim_custom_plugins = [
\ ['plasticboy/vim-markdown', {'on_ft' : 'markdown'}],
\ ]

" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile
