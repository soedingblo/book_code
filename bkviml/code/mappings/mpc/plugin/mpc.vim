function! OpenMPC()
  if(bufexists('mpc.mpdv'))
    let mpcwin = bufwinnr('mpc.mpdv')
    if(mpcwin == -1)
      execute "new | buffer " . bufnr('mpc.mpdv')
    else
      execute mpcwin . 'wincmd w'
      return
    endif
  else
    execute "new mpc.mpdv"
  endif
  call mpc#DisplayPlaylist() 
endfunction

"START:commandOpenMpc
command! MpcBrowser call OpenMPC()
"END:commandOpenMpc
"START:commandTogglePlayback
command! TogglePlayback   call mpc#TogglePlayback()
"END:commandTogglePlayback
