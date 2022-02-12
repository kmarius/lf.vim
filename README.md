lfm.vim
======

[lfm](https://github.com/kmarius/lfm) integration in vim and neovim

Installation
------------

Install it with your favorite plugin manager. Example with vim-plug:

        Plug 'kmarius/lfm.vim'

Then, add the vim-floaterm dependency:

        Plug 'voldikss/vim-floaterm'

**Note:** lfm.vim should be loaded before vim-floaterm to override vim-floaterm's lfm wrapper.

How to use it
-------------

The default shortcut for opening lfm is `<leader>f` (\f by default).
To disable the default key mapping, add this line in your .vimrc or init.vim: `let g:lfm_map_keys = 0`.
Then you can add a new mapping with this line: `map <leader>f :Lfm<CR>`.

To set the floating window width and height, set `g:lfm_width` and `g:lfm_height` accordingly. If not found, it will default to `g:floaterm_width` and `g:floaterm_height`.

The command for opening lfm in the current file's directory is `:Lfm`.
When opening (default 'l' and '\<right\>') a file from the lfm window,
vim will open the selected file in the current window. To open the selected
file in a new tab instead use `:LfmNewTab`.

(Note that the lfm `open` command is required to return to the originating vim session.
E.g. the `edit` command opens a new process of $EDITOR.)

For opening lfm in the current workspace, run `:LfmWorkingDirectory`.
Vim will open the selected file in the current window.
`:LfmWorkingDirectoryNewTab` will open the selected file in a new tab instead.

For changing the current directory via lfm, run `:Lfmcd`or run `:Lfmlcd` for the current window.

List of commands:
```vim
" Change directory with lfm via cd or lcd
Lfmcd
Lfmlcd

Lfm " Open current file by default
LfmCurrentFile " Default Lfm behaviour
LfmCurrentDirectory
LfmWorkingDirectory

" Always open in new tabs
LfmNewTab
LfmCurrentFileNewTab
LfmCurrentDirectoryNewTab
LfmWorkingDirectoryNewTab

" Open tab if it exists or in new tab if it does not
LfmCurrentFileExistingOrNewTab
LfmCurrentDirectoryExistingOrNewTab
LfmWorkingDirectoryExistingOrNewTab
```

The old way to make vim open the selected file in a new tab was to add
`let g:lfm_open_new_tab = 1` in your .vimrc or init.vim. That way is still
supported but deprecated.

### Opening lfm instead of netrw when you open a directory
If you want to see vim opening lfm when you open a directory (ex: nvim ./dir or :edit ./dir), please add this in your .(n)vimrc.
```vim
let g:NERDTreeHijackNetrw = 0 " Add this line if you use NERDTree
let g:lfm_replace_netrw = 1 " Open lfm when vim opens a directory
```

### Setting a custom lfm command
By default lfm is opened with the command `lfm` but you can set an other custom command by setting the `g:lfm_command_override` variable in your .(n)vimrc.

For instance if you want to display the hidden files by default you can write:
```vim
let g:lfm_command_override = 'lfm -command "set hidden"'
```
