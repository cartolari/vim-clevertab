"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:ExitInsertAndComplete(completion)
  return "\<Esc>a" . a:completion
endfunction

function! CleverTab#Complete(type)
  "echom "type: " . a:type

  if a:type == 'start'
    if !exists("g:CleverTab#next_step_direction")
      echom "Clevertab Start"
      let g:CleverTab#next_step_direction="0"
    endif
    let g:CleverTab#last_cursor_col=virtcol('.')
    let g:CleverTab#cursor_moved=0
    let g:CleverTab#eat_next=0
    let g:CleverTab#autocmd_set=1
    let g:CleverTab#stop=0
    return ""
  endif
  let g:CleverTab#cursor_moved=g:CleverTab#last_cursor_col!=virtcol('.')


  if a:type == 'tab' && !g:CleverTab#stop
    if strpart( getline('.'), 0, col('.')-1 ) !~ '\k' " =~ '^\s*$'
      let g:CleverTab#stop=1
      echom "Regular Tab"
      let g:CleverTab#next_step_direction="0"
      return "\<TAB>"
    endif


  elseif a:type == 'omni' && !pumvisible() && !g:CleverTab#cursor_moved && !g:CleverTab#stop
    if &omnifunc != ''
      echom "Omni Complete"
      let g:CleverTab#next_step_direction="N"
      let g:CleverTab#eat_next=1
      return s:ExitInsertAndComplete("\<C-X>\<C-O>")
    endif


  elseif a:type == 'keyword' && !pumvisible() && !g:CleverTab#cursor_moved && !g:CleverTab#stop
    echom "Keyword Complete"
    let g:CleverTab#next_step_direction="P"
    let g:CleverTab#eat_next=1
    return s:ExitInsertAndComplete("\<C-P>")


  elseif a:type == 'ultisnips' && !g:CleverTab#cursor_moved && !g:CleverTab#stop
    let g:ulti_x = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res
      echom "Ultisnips"
      let g:CleverTab#next_step_direction="0"
      let g:CleverTab#stop=1
      return g:ulti_x
    endif
    return ""


  elseif a:type == 'next'
    if !pumvisible()
      return ""
    end
    let g:CleverTab#stop=1
    if g:CleverTab#next_step_direction=="P"
      return "\<C-P>"
    else
      return "\<C-N>"
    endif

  elseif a:type == "forcedtab" && !g:CleverTab#stop
    echom "Forcedtab"
    let g:CleverTab#next_step_direction="0"
    let g:CleverTab#stop=1
    return "\<Tab>"


  elseif a:type == "stop"
    if g:CleverTab#stop || g:CleverTab#eat_next==1
      let g:CleverTab#stop=0
      let g:CleverTab#eat_next=0
      return ""
    endif
    if g:CleverTab#next_step_direction=="P"
      return "\<C-P>"
    elseif g:CleverTab#next_step_direction=="N"
      return "\<C-N>"
    endif


  elseif a:type == "prev"
    if g:CleverTab#next_step_direction=="P"
      return "\<C-N>"
    elseif g:CleverTab#next_step_direction=="N"
      return "\<C-P>"
    endif
  endif


  return ""
endfunction
