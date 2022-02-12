" Copyright (c) 2015 François Cabrol
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


" ================ Lfm =======================
if exists('g:lfm_command_override')
  let s:lfm_command = g:lfm_command_override
else
  let s:lfm_command = 'lfm'
endif

function! OpenLfmIn(path, edit_cmd)
  let currentPath = shellescape(isdirectory(a:path) ? fnamemodify(expand(a:path), ":p:h") : expand(a:path))
  let s:edit_cmd = a:edit_cmd
  if exists(":FloatermNew")
    exec 'FloatermNew' . ' --height=' . string(get(g:, 'lfm_height', g:floaterm_height)) . ' --width=' . string(get(g:, 'lfm_width', g:floaterm_width)) . ' ' . s:lfm_command . ' ' . currentPath
  else
    echoerr "Failed to open a floating terminal. Make sure `voldikss/vim-floaterm` is installed."
  endif
endfun

function! LfmCallback(lfm_tmpfile, lastdir_tmpfile, ...) abort
  let edit_cmd = get(s:, 'edit_cmd', 'default')
  if (edit_cmd == 'cd' || edit_cmd == 'lcd') && filereadable(a:lastdir_tmpfile)
    let lastdir = readfile(a:lastdir_tmpfile, '', 1)[0]
    if lastdir != getcwd()
      exec edit_cmd . ' ' . lastdir
      return
    endif
  elseif filereadable(a:lfm_tmpfile)
    let filenames = readfile(a:lfm_tmpfile)
    if !empty(filenames)
      if has('nvim')
        call floaterm#window#hide(bufnr('%'))
      endif
      let locations = []
      let floaterm_opener = edit_cmd != 'default' ? s:edit_cmd : g:floaterm_opener
      for filename in filenames
        let dict = {'filename': fnamemodify(filename, ':p')}
        call add(locations, dict)
      endfor
      call floaterm#util#open(locations, floaterm_opener)
      unlet! s:edit_cmd
    endif
  endif
endfunction

" For backwards-compatibility (deprecated)
if exists('g:lfm_open_new_tab') && g:lfm_open_new_tab
  let s:default_edit_cmd='tabedit'
else
  let s:default_edit_cmd='edit'
endif

command! Lfmcd call OpenLfmIn(".", 'cd')
command! Lfmlcd call OpenLfmIn(".", 'lcd')
command! LfmCurrentFile call OpenLfmIn("%", s:default_edit_cmd)
command! LfmCurrentDirectory call OpenLfmIn("%:p:h", s:default_edit_cmd)
command! LfmWorkingDirectory call OpenLfmIn(".", s:default_edit_cmd)
command! Lfm LfmCurrentFile

" To open the selected file in a new tab
command! LfmCurrentFileNewTab call OpenLfmIn("%", 'tabedit')
command! LfmCurrentFileExistingOrNewTab call OpenLfmIn("%", 'tab drop')
command! LfmCurrentDirectoryNewTab call OpenLfmIn("%:p:h", 'tabedit')
command! LfmCurrentDirectoryExistingOrNewTab call OpenLfmIn("%:p:h", 'tab drop')
command! LfmWorkingDirectoryNewTab call OpenLfmIn(".", 'tabedit')
command! LfmWorkingDirectoryExistingOrNewTab call OpenLfmIn(".", 'tab drop')
command! LfmNewTab LfmCurrentDirectoryNewTab

" For retro-compatibility
function! OpenLfm()
  Lfm
endfunction

" To open lfm when vim load a directory
if exists('g:lfm_replace_netrw') && g:lfm_replace_netrw
  augroup ReplaceNetrwByLfmVim
    autocmd VimEnter * silent! autocmd! FileExplorer
    autocmd BufEnter * let s:buf_path = expand("%") | if isdirectory(s:buf_path) | bdelete! | call timer_start(100, {->OpenLfmIn(s:buf_path, s:default_edit_cmd)}) | endif
  augroup END
endif

if !exists('g:lfm_map_keys') || g:lfm_map_keys
  map <leader>f :Lfm<CR>
endif
