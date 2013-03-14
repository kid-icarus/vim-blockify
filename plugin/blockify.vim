" Copyright (c) 2013 Marco Hinz
" All rights reserved.
"
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are met:
"
" - Redistributions of source code must retain the above copyright notice, this
"   list of conditions and the following disclaimer.
" - Redistributions in binary form must reproduce the above copyright notice,
"   this list of conditions and the following disclaimer in the documentation
"   and/or other materials provided with the distribution.
" - Neither the name of the author nor the names of its contributors may be
"   used to endorse or promote products derived from this software without
"   specific prior written permission.
"
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
" IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
" ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
" LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
" CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
" SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
" INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
" CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
" ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
" POSSIBILITY OF SUCH DAMAGE.

if exists('g:loaded_blockify') || &cp || !exists('##CursorMoved') || !exists('##CursorMovedI')
  finish
endif
let g:loaded_blockify = 1

let s:group = exists('g:blockify_highlight_group') ? g:blockify_highlight_group : 'MatchParen'

let g:blockify_pairs = {
      \ 'c':    [ '{', '}' ],
      \ 'cpp':  [ '{', '}' ],
      \ 'java': [ '{', '}' ],
      \}

autocmd BufEnter *
      \ if has_key(g:blockify_pairs, &ft) |
      \   exe 'autocmd CursorMoved,CursorMovedI <buffer> call s:highlight_block()' |
      \ endif

function! s:highlight_block() abort
  if exists('s:match')
    call matchdelete(s:match)
  endif

  let char_open  = g:blockify_pairs[&ft][0]
  let char_close = g:blockify_pairs[&ft][1]

  if matchstr(getline('.'), '.', col('.')-1) != char_open
    let pos_open = searchpairpos(char_open, '', char_close, 'Wnb')
  endif
  if matchstr(getline('.'), '.', col('.')-1) != char_close
    let pos_close = searchpairpos(char_open, '', char_close, 'Wn')
  endif

  if exists('pos_open') && exists('pos_close')
    let s:match = matchadd(s:group, '\%(\%'. pos_open[0] .'l\%'. pos_open[1] .'c\)\|\(\%'. pos_close[0] .'l\%'. pos_close[1] .'c\)', 42, 666)
  elseif exists('pos_open')
    let s:match = matchadd(s:group, '\%(\%'. pos_open[0] .'l\%'. pos_open[1] .'c\)', 42, 666)
  else
    let s:match = matchadd(s:group, '\%(\%'. pos_close[0] .'l\%'. pos_close[1] .'c\)', 42, 666)
  endif
endfunction

" vim:set et sw=2 sts=2:
