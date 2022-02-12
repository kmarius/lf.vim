function! floaterm#wrapper#lfm#(cmd, jobopts, ...) abort
  let lfm_tmpfile = tempname()
  let lastdir_tmpfile = tempname()
  let original_dir = getcwd()
  lcd %:p:h

  let cmdlist = split(a:cmd)
  let cmd = 'lfm -l "' . lastdir_tmpfile . '" -s "' . lfm_tmpfile . '"'
  if len(cmdlist) > 1
    let cmd .= ' ' . join(cmdlist[1:], ' ')
  else
    let cmd .= ' "' . getcwd() . '"'
  endif

  exe "lcd " . original_dir
  let cmd = [&shell, &shellcmdflag, cmd]
  let a:jobopts.on_exit = funcref('LfmCallback', [lfm_tmpfile, lastdir_tmpfile])
  return [v:false, cmd]
endfunction
