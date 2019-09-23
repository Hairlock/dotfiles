syntax enable
filetype plugin indent on

set nocompatible
set path+=**

set wildmenu
set wildmode=longest,list,full
set wildignore+=*\\tmp*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
set completeopt+=longest

:set number relativenumber
:set nu rnu

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
set cmdheight=1

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
nnoremap <Tab> :bn<CR>
nnoremap <S-Tab> :bp<CR>
nnoremap <c-w> :bd!<CR>


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


function! Haskell_add_language_pragma()
  let line = max([0, search('^{-# LANGUAGE', 'n') - 1])
  :call fzf#run({
  \ 'source': 'ghc --supported-languages',
  \ 'sink': {lp -> append(line, "{-# LANGUAGE " . lp . " #-}")},
  \ 'options': '--multi --ansi --reverse --prompt "LANGUAGE> "',
  \ 'down': '25%'})
endfunction

command! LP :call Haskell_add_language_pragma()

let g:hdevtools_stack = 1
au FileType haskell nnoremap <buffer> <F1> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> <F2> :HdevtoolsInfo<CR>
au FileType haskell nnoremap <buffer> <silent> <F3> :HdevtoolsClear<CR>

" Use * to search in visual mode
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>

nnoremap <silent> <Leader>rg :Rg <C-R><C-W><CR>

" Exit terminal mode naturally
if has("nvim")
  au TermOpen * tnoremap <Esc> <c-\><c-n>
  au FileType fzf tunmap <Esc>
endif

" Make sure vim-plug is installed
if empty(glob("~/.config/nvim/plugged"))
    silent !curl -fLo ~/.config/nvim/plugged --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
    source $MYVIMRC
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

" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'godlygeek/tabular'
" Plug 'bitc/vim-hdevtools'

Plug 'NLKNguyen/papercolor-theme'

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
nnoremap <f5> :!ctags -R<CR>

" Tabularize config
if exists(":Tabularize")
  nmap <Leader>t= :Tabularize /=<CR>
  vmap <Leader>t= :Tabularize /=<CR>
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
let g:NERDTreeShowHidden = 1
let g:NERDTreeWinSize = 35
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeIgnore = ['\.git$']
let g:NERDTreeRespectWildIgnore = 1


" Lightline Config
let g:lightline = {
\   'colorscheme': 'powerline',
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
nnoremap <leader>gp :Ggrep<leader>
nnoremap <leader>gm :Gmove<leader>
nnoremap <leader>gb :Git branch<leader>
nnoremap <leader>go :Git checkout<leader>
nnoremap <leader>gps :Dispatch! git push<CR>
nnoremap <leader>gpl :Dispatch! git pull<CR>

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
