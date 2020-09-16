" nnoremap <silent> <C-S-p> :lua v:lua.palette.open("rounded", "center") <CR>
" noremap <silent> <C-S-p> :lua require'color'.open("rounded", "center") <CR>
" inoremap <silent> <C-S-p> <Esc> <C-o>: lua require'color'.open("rounded", "center") <CR>
" command! BorderDraw lua require'palette'.border_draw("rounded")
" function s:set_color_theme()
"     " let buf_game, win_game = lua require'hello'.set_color_theme()
"     lua require'command_palette'.open_command_palette() 
"     " return buf_game, win_game
" endfunction

" let g:buf_game = none
" , g:win_game
" command! OpenGame call s:set_color_theme()
" augroup Palette 
"     autocmd!
"     autocmd WinEnter * call s:handle_palette()
" augroup END

" function s:handle_palette()
"     " colorscheme dracula
"     nvim_win_set_option(0, 'colorscheme', 'dracula')
" endfunction
" function s:set_color_theme()
"     lua require'color_theme'.SetColorTheme()
" endfunction

hi Hel ctermbg=white ctermfg=blue guifg=#000000
hi Title ctermbg=white ctermfg=blue guifg=#000000
" augroup Window
"     autocmd!
"     autocmd BufEnter filetype window :call nvim_buf_add_highlight(0, -1, 'Hel', 0, 0, -1)
" augroup END

" if exists('g:load_palette') 
"     finish
" endif

" let g:load_palette = 1
" let s:save_cpo = &cpo
" set cpo&vim

let g:palette#config#file='~/.config/nvim/palette-config.lua'
nnoremap <silent> <C-S-p> :lua require'palette'["open"]("rounded", "center") <CR>

" let &cpo = s:save_cpo
" unlet s:save_cpo

