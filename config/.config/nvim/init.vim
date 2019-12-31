syntax enable
filetype plugin indent on

set nocompatible
set path+=**

set wildmenu
set wildmode=longest,list,full
set wildignore+=*\\tmp*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
set completeopt+=longest

set nu
set showtabline=2
set autoread
set lazyredraw

set shell=bash
set encoding=utf8
set secure     " No arbitrary commands can run from foreign vimrcs
set cursorline " Highlight the current line
set autoread  " Autoreload from disk
set noswapfile
set updatecount=0 " Disable swap files
" set colorcolumn=80 "Ruler at 80 chars
set nofoldenable "Disable code folding
set clipboard+=unnamedplus " Use system clipboard for yanks
set textwidth=80 " Wrap text at 80 chars
set updatetime=100
set backupcopy=yes " For file watchers
set cmdheight=2

set tabstop=2
set shiftwidth=2
set softtabstop=2
set shiftround " Indent/Outdent to the nearest tabstop
set expandtab " Use spaces instead of tabs
set smarttab  " Use tabs at the start of a line, spaces elsewhere


set history=1000
set ruler
set showcmd
set number
set showmode
set smarttab
set smartindent
set ai
set si
set lbr
set autoindent
set expandtab
set tags=tags
set hidden
set hid
set ignorecase
set scrolloff=5

set smartcase
set incsearch
set nohlsearch

" Backspace behavior
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set mouse=a

set diffopt=filler,vertical

" Local spaces by filetype
autocmd Filetype nix setlocal ts=2 sw=2 expandtab


" Set Leader keys
let mapleader = ','
let maplocalleader = ','

" Autocmds
function! Hashbang(portable, permission, RemExt)
let shells = {
        \     'sh': "env sh",
        \    }

let extension = expand("%:e")

if has_key(shells,extension)
	let fileshell = shells[extension]

	if a:portable
		let line =  "#!/run/current-system/sw/bin/" . fileshell
	else
		let line = "#! " . system("which " . fileshell)
	endif

	0put = line

	if a:permission
		:autocmd BufWritePost * :autocmd VimLeave * :!chmod u+x %
	endif


	if a:RemExt
		:autocmd BufWritePost * :autocmd VimLeave * :!mv % "%:p:r"
	endif

endif

endfunction

:autocmd BufNewFile *.sh :call Hashbang(1,1,0)

" Ctrl+arrow to resize pane
nnoremap <c-down>  :resize -2<CR>
nnoremap <c-left>  :vertical resize -2<CR>
nnoremap <c-right> :vertical resize +2<CR>
nnoremap <c-up>    :resize +2<CR>

" Delete without copy
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP

" Buffer navigation shortcuts
nnoremap <C-]> :bn<CR>
nnoremap <C-[> :bp<CR>
nnoremap <S-w> :bd!<CR>

" View set marks
nnoremap <F1> :<C-u>marks<CR>:normal! `
function! Marks()
    marks
    echo('Mark: ')

    " getchar() - prompts user for a single character and returns the chars
    " ascii representation
    " nr2char() - converts ASCII `NUMBER TO CHAR'

    let s:mark = nr2char(getchar())
    " remove the `press any key prompt'
    redraw

    " build a string which uses the `normal' command plus the var holding the
    " mark - then eval it.
    execute "normal! '" . s:mark
endfunction

nnoremap ' :call Marks()<CR>
function! GoBuf()
  bnext
  echon '    '
  for buf in range(1, bufnr('$'))
    echon '['
    if bufloaded(buf)
      echohl WarningMsg | echon bufname(buf) | echohl None
    else
      echon bufname(buf)
    endif
    echon ']  '
  endfor
endfunction
map <F8> :call GoBuf()<CR>


map <leader>q :q!<CR>
map <leader>w :w!<CR>
map <leader>e :wq!<CR>
map <leader>s :source /home/yannick/.config/nvim/init.vim<CR>
nnoremap th <C-w>h
nnoremap tj <C-w>j
nnoremap tk <C-w>k
nnoremap tl <C-w>l
inoremap jk <Esc>
inoremap jj <CR><C-R>=repeat(' ',col([line('.')-1,'$'])-col('.'))<CR><C-O>:.retab<CR>

" Plain arrows move text around
nmap <up>    [e
nmap <down>  ]e
nmap <left>  <<
nmap <right> >>
vmap <up>    [egv
vmap <down>  ]egv
vmap <left>  <gv
vmap <right> >gv

" :T creates a new terminal split (VT for a vertical split)
command! -nargs=* T  below split | terminal <args>
command! -nargs=* VT below vsplit | terminal <args>

command! SpellEnable  setlocal spell spelllang=en_gb
command! SpellDisable setlocal nospell

augroup TerminalStuff
    au!
    autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

" Fzf Hoogle
augroup HoogleMaps
  autocmd!
  autocmd FileType haskell nnoremap <buffer> <leader>hh :Hoogle <c-r>=expand("<cword>")<CR><CR>
augroup END
"let g:hoogle_path = /"/home/yannick/.nix-profile/bin/hoogle"


function! Haskell_add_language_pragma()
  let line = max([0, search('^{-# LANGUAGE', 'n') - 1])
  :call fzf#run({
  \ 'source': 'ghc --supported-languages',
  \ 'sink': {lp -> append(line, "{-# LANGUAGE " . lp . " #-}")},
  \ 'options': '--multi --ansi --reverse --prompt "LANGUAGE> "',
  \ 'down': '25%'})
endfunction

command! LP :call Haskell_add_language_pragma()

" Use * to search in visual mode
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>

nnoremap <silent> <Leader>rg :Rg <C-R><C-W><CR>

" Exit terminal mode naturally
if has("nvim")
  au TermOpen * tnoremap <Esc> <c-\><c-n>
  au FileType fzf tunmap <Esc>
endif

" Load Plugins
call plug#begin('~/.config/nvim/plugged')

Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
Plug 'LnL7/vim-nix'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-obsession'

Plug 'andys8/vim-elm-syntax'

" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'monkoose/fzf-hoogle.vim'
Plug 'glacambre/firenvim', { 'do': function('firenvim#install') }
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
" Plug 'bitc/vim-hdevtools'

Plug 'NLKNguyen/papercolor-theme'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'nathanaelkane/vim-indent-guides'

call plug#end()

" Remaps
" Disable hlsearch on ctrl-l
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Search based on visual select
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

" Rerun last substitution with flags
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Regenerate CTAGS
nnoremap <f5> :IndentGuidesToggle<CR>

" Tabularize config
if exists(":Tabularize")
  nmap <Leader>t= :Tabularize /=<CR>
  vmap <Leader>t= :Tabularize /=<CR>
  nmap <Leader>t- :Tabularize /-<CR>
  vmap <Leader>t- :Tabularize /-<CR>
  nmap <Leader>t: :Tabularize /:\zs<CR>
  vmap <Leader>t: :Tabularize /:\zs<CR>
  nmap <Leader>t< :Tabularize /<-<CR>
  vmap <Leader>t< :Tabularize /<-<CR>
  nmap <Leader>t> :Tabularize /-><CR>
  vmap <Leader>t> :Tabularize /-><CR>
endif

" CoC config
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)


" Fzf Config
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})
" nmap <c-p> :GitFiles<cr>
map <c-p> :Files<cr>

" Session management config
nnoremap <c-s> :Obsession <CR>


" Ale Config
let g:ale_linters = {
\   'sh': ['shellcheck'],
\   'nix': ['nix'],
\   'make': ['checkmake'],
\   'haskell': ['hlint'],
\   'purescript': ['purescript-language-server'],
\   'elm': ['make'],
\}

" \   'haskell': ['hlint'],
let g:ale_linters_explicit = 1 " Only use specified linters

let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_completion_enabled = 1

" https://github.com/w0rp/ale/blob/master/autoload/ale/fix/registry.vim
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'elm': ['elm-format'],
\   'sh': ['shfmt'],
\   'dhall': ['DhallFormat'],
\   'haskell': ['stylish-haskell'],
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'json': ['prettier'],
\   'css': ['prettier'],
\   'scss': ['prettier'],
\   'less': ['prettier'],
\   'markdown': ['prettier'],
\   'yaml': ['prettier'],
\}
let g:ale_fix_on_save = 1

let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_set_highlights = 0

" NerdTree Config
map  <c-n>     :NERDTreeToggle<cr>
nmap <leader>n :NERDTreeFind<cr>

let g:NERDTreeWinPos = 'left'
let g:NERDTreeShowHidden = 0
let g:NERDTreeWinSize = 35
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeIgnore = ['\.git$']
let g:NERDTreeRespectWildIgnore = 1


" Lightline Config
let g:lightline = {
\   'colorscheme': 'powerline',
\   'tabline'          : {'left': [['buffers']], 'right': [['close']]},
\   'component_expand' : {'buffers': 'lightline#bufferline#buffers'},
\   'component_type'   : {'buffers': 'tabsel'},
\   'inactive': {
\       'left': [
\           [ 'absolutepath' ]
\       ]
\   },
\   'active': {
\       'left': [
\           [ 'mode', 'paste' ],
\           [ 'gitbranch', 'readonly', 'absolutepath', 'modified' ]
\       ]
\   },
\   'component_function': {
\       'gitbranch': 'fugitive#head'
\   },
\   'separator': { 'left': '|', 'right': '|' },
\}

let g:lightline#bufferline#show_number  = 2
let g:lightline#bufferline#number_map = {
\ 0: '⁰', 1: '¹', 2: '²', 3: '³', 4: '⁴',
\ 5: '⁵', 6: '⁶', 7: '⁷', 8: '⁸', 9: '⁹'}

nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)

" fugitive git bindings
nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Git commit -v -q<CR>
nnoremap <leader>gt :Git commit -v -q %:p<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>ge :Gedit :0<CR>
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gw :Gwrite<CR><CR>
nnoremap <leader>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <leader>gph :Gpush<CR>
nnoremap <leader>gpl :Gpull<CR>
nnoremap <leader>gm :Gmove<leader>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>go :Git checkout<leader>

vmap <silent> u <esc>:Gdiff<cr>gv:diffget<cr><c-w><c-w>ZZ

" PaperColor Config
let g:PaperColor_Theme_Options = {'theme': {'default.dark': { 'transparent_background': 1 } } }
colorscheme PaperColor
set background=dark

command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
let buffer_numbers = {}
for quickfix_item in getqflist()
let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
endfor
return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

inoremap <silent> <buffer> <bar> <bar><esc>:call <SID>align()<cr>a
function! s:align()
  if exists(':Tabularize') && line('.') > 1 && getline(line('.') - 1) =~ '|' && getline('.')[0:col('.')] =~ '^\s*|$'
    if getline(line('.') - 1) =~ '^\s*|'
      Tabularize/^\s*\zs|/
    else
      Tabularize/^[^|]*\zs|/
    endif
    normal! 0f|
  endif
endfunction

" Highlight character at col 80
highlight ColorColumn ctermbg=magenta guibg=Magenta
call matchadd('ColorColumn', '\%81v', 100)


function! ApplyOneSuggestion()
  let l = line(".")
  let c = col(".")
  let l:filter = "%! hlint - --refactor  --refactor-options=\"--pos ".l.','.c."\""
  execute l:filter
  silent if v:shell_error == 1| undo | endif
  call cursor(l, c)
endfunction


function! ApplyAllSuggestions()
  let l = line(".")
  let c = col(".")
  let l:filter = "%! hlint - --refactor"
  execute l:filter
  silent if v:shell_error == 1| undo | endif"
  call cursor(l, c)
endfunction


if ( ! exists('g:hlintRefactor#disableDefaultKeybindings') ||
   \ ! g:hlintRefactor#disableDefaultKeybindings )

  map <silent> to :call ApplyOneSuggestion()<CR>
  map <silent> ta :call ApplyAllSuggestions()<CR>

endif


"Delete the buffer; keep windows; create a scratch buffer if no buffers left
function s:Kwbd(kwbdStage)
  if(a:kwbdStage == 1)
    if(&modified)
      let answer = confirm("This buffer has been modified.  Are you sure you want to delete it?", "&Yes\n&No", 2)
      if(answer != 1)
        return
      endif
    endif
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:kwbdBufNum = bufnr("%")
    let s:kwbdWinNum = winnr()
    windo call s:Kwbd(2)
    execute s:kwbdWinNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:kwbdBufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:kwbdWinNum . 'wincmd w'
    endif
    if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
      execute "bd! " . s:kwbdBufNum
    endif
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
  else
    if(bufnr("%") == s:kwbdBufNum)
      let prevbufvar = bufnr("#")
      if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
        b #
      else
        bn
      endif
    endif
  endif
endfunction

command! Kwbd call s:Kwbd(1)
nnoremap <silent> <Plug>Kwbd :<C-w>Kwbd<CR>

" Create a mapping (e.g. in your .vimrc) like this:
nnoremap <silent> <C-w> :Kwbd <CR>


" Go to Jump script
function! GotoJump()
  jumps
  let j = input("Please select your jump: ")
  if j != ''
    let pattern = '\v\c^\+'
    if j =~ pattern
      let j = substitute(j, pattern, '', 'g')
      execute "normal " . j . "\<c-i>"
    else
      execute "normal " . j . "\<c-o>"
    endif
  endif
endfunction

nnoremap <silent> <Leader>j :call GotoJump()<CR>
