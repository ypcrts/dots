" vi: ft=vim

if empty(glob(g:libdir . '/plug.vim'))
  silent call system('mkdir -p ' . g:libdir . '/{autoload,bundle,cache,undo,backups,swaps}')
  silent call system('curl -fLo ' . g:libdir . '/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
endif

call Sourceiffr(g:libdir . '/plug.vim')

if has('python') || has('python3') || has('nvim')
  call plug#begin( g:configdir . '/plugged')

  Plug 'ypcrts/securemodelines', { 'commit': '9751f29699186a47743ff6c06e689f483058d77a' }
  " Plug 'jamessan/vim-gnupg'
  " Plug 'ypcrts/vim-gpg-sign'

  Plug 'editorconfig/editorconfig-vim'
  Plug 'Konfekt/FastFold'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-unimpaired'
  Plug 'itchyny/lightline.vim'
  Plug 'nishigori/increment-activator'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'scrooloose/nerdcommenter'
  Plug 'junegunn/vim-easy-align'

  Plug 'chrisbra/NrrwRgn'

  Plug '~/.fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/vim-peekaboo'
  Plug 'jremmen/vim-ripgrep'

  " Plug 'chrisbra/vim-diff-enhanced'

  " Linting
  " PICK ONE STOP CHANGING LINT PLUGINS YOU'RE DRIVING YOURSELF MAD
  if has('nvim') || v:version >= 800
    Plug 'w0rp/ale'
  else
    Plug 'scrooloose/syntastic'
  endif
  Plug 'heavenshell/vim-pydocstring', { 'for': 'python' }
  Plug 'fisadev/vim-isort', { 'for': 'python' }

  " Completion
  if has('nvim')
    " deoplete does not work on vim8, stop hoping, cry
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'Shougo/neoinclude.vim'
    Plug 'zchee/deoplete-jedi'
    " Plug 'zchee/deoplete-clang'
    Plug 'tweekmonster/deoplete-clang2', { 'commit': '787dd4dc7eeb5d1bc2fd3cefcf7bd07e48f4a962' }
  else
    "Plug 'valloric/youcompleteme', { 'do': 'echoerr \"You need to go compile YCM\"' }
  endif

  " NEVER USE THIS IT IS HORRIBLE, STOP LOVING IT
  " Plug 'jiangmiao/auto-pairs'

  Plug 'mattn/emmet-vim'

  " Syntax etc
  " Plug 'sheerun/vim-polyglot' " 6d6574617061636b616765207365637572697479207269736b206666730a
  Plug '~/Projects/ansible-vim', { 'branch': 'j2-commentstring' }
  Plug 'tweekmonster/django-plus.vim'
  Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  Plug 'racer-rust/vim-racer', { 'for': 'rust' }
  Plug 'cespare/vim-toml', { 'for': 'toml' }

  " Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
  Plug 'ypcrts/vim-ini-fold',          { 'commit': 'b61a9ab242a316d2ba755c36c96888416162f1f4', 'for': ['gitignore','gitconfig','ini'] }
  Plug 'ypcrts/vim-uncrustify',        { 'commit': 'bcf54fff8d58e0f4276ba22077562ead9814096a', 'for': ['c','cpp']  }
  " Plug 'bigfish/vim-js-context-coloring', { 'commit': '6c90329664f3b0a58b05e2a5207c94da0d83a51c', 'for': 'javascript', 'do': 'nvm use 6 && npm install --upgrade' }
  " Plug 'digitaltoad/vim-jade', { 'for': ['jade'] }
  " Plug 'git://fedorapeople.org/home/fedora/wwoods/public_git/vim-scripts.git' "systemd
  " Plug 'PotatoesMaster/i3-vim-syntax'
  Plug 'tmhedberg/SimpylFold', { 'for': 'python', 'commit': '4624031f65d78196d55be0180a31bd352460aebc' }

  " RE
  " Plug 'CaledoniaProject/VIM-IDC'
  " Plug 'alderz/smali-vim'

  " Git/VCS
  Plug 'airblade/vim-gitgutter'
  Plug 'tpope/vim-fugitive'

  " TODO: cr die webapi-vim neuigkeiten, scheiße
  Plug 'mattn/gist-vim',     { 'commit': 'f0d63579eab7548cf12f979dc52ef5a370ecbe63' }
  Plug 'mattn/webapi-vim',   { 'commit': 'e3fa93f29a3a0754204002775e140d8a9acfd7fd' }

  " Colour
  Plug 'w0ng/vim-hybrid'
  Plug 'nanotech/jellybeans.vim'
  Plug 'guns/jellyx.vim'
  Plug 'fisadev/fisa-vim-colorscheme'
  Plug 'whatyouhide/vim-gotham' ",      { 'commit': 'f46412d4f9768c332ae22676f3ef4cc130457ba0' }
  Plug 'djjcast/mirodark',             { 'commit': '306c5f96dd0ecaa64eac603b990a22300dc798f7' }
  Plug 'lu-ren/SerialExperimentsLain', { 'commit': 'aabb800d6a27cde243604a94a9a14334286a87b2' }
  Plug 'zcodes/vim-colors-basic',      { 'commit': 'bdf14db578ad283bffa019ab2236f4d378eef34b' }
  Plug 'lifepillar/vim-solarized8' ",    { 'commit': 'dc6c1dfa6f5c068ba338b8a2e4f88f4b6de4433a' }
  if !has('nvim') " nvim no work? 16-bit
    Plug 'laserswald/chameleon.vim',   { 'commit': 'e7c9991fa19961dd2bcf89e92f09be1da89b8c77' }
  endif
  " Plug 'nightsense/vim-crunchbang'
  " Plug 'flazz/vim-colorschemes'

  call plug#end()
else
  echoerr "I do not have python. I am ugly. You might as well use emacs."
endif

let g:nrrw_rgn_nomap_nr = 1  " disable worlds worst default maps
let g:nrrw_rgn_nomap_Nr = 1

let g:gitgutter_enabled = 1
let g:gitgutter_map_keys = 0

" flake8-vim
let g:PyFlakeCWindow = 0

" deoplete is life
let g:deoplete#enable_at_startup = 1

" pymode, rip
" let g:pymode_lint_cwindow = 0
" let g:pymode_doc_bind = ''
" let g:pymode_virtualenv = 0

" ycm, rip
"let g:ycm_key_invoke_complete = '' "<C-Space> === <NUL>
" let g:ycm_key_detailed_diagnostics = '<leader>yd'
" let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<C-n>']
" let g:ycm_autoclose_preview_window_after_completion = 1
" let g:ycm_autoclose_preview_window_after_insertion  = 1
" let g:ycm_semantic_triggers =  {
"       \   'c' : ['->', '.'],
"       \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
"       \             're!\[.*\]\s'],
"       \   'ocaml' : ['.', '#'],
"       \   'cpp,objcpp' : ['->', '.', '::'],
"       \   'perl' : ['->'],
"       \   'php' : ['->', '::'],
"       \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
"       \   'python' : ['.', 'from ', 'import '],
"       \   'ruby' : ['.', '::'],
"       \   'lua' : ['.', ':'],
"       \   'erlang' : [':'],
"       \ }

let g:js_context_colors_enabled = 0
let g:js_context_colors_usemaps = 0
let g:js_context_colors_highlight_function_names = 0

let g:javascript_plugin_jsdoc = 1

" let g:polyglot_disabled = ['javascript']

let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_on_enter = 0
let g:ale_lint_delay = 5000
let g:ale_sign_error = 'E'
let g:ale_sign_warning = 'W'
let g:ale_echo_cursor = 1
let g:ale_echo_msg_format = '[%linter%] %severity%: %s'
let g:ale_list_window_size = 6
let g:ale_linters = { 'python': ['flake8'] } " merged dict; no pylint in ale please

let g:syntastic_javascript_checkers = [ 'eslint' ]
let g:syntastic_python_checkers = [ 'flake8' ]

let g:pydocstring_enable_mapping = 0

let g:NERDSpaceDelims = 1
let g:NERDMenuMode    = 0

let g:increment_activator_no_default_key_mappings = 1
let g:increment_activator_filetype_candidates =
      \ {
      \ '_': [
      \   [
      \     's:black', 's:red', 's:green', 's:yellow', 's:blue', 's:magenta',
      \     's:cyan', 's:white', 's:blackb', 's:redb', 's:greenb', 's:yellowb',
      \     's:blueb', 's:magentab', 's:cyanb', 's:whiteb'
      \   ],
      \   [
      \     'black', 'red', 'green', 'yellow', 'blue', 'magenta',
      \     'cyan', 'white', 'blackb', 'redb', 'greenb', 'yellowb',
      \     'blueb', 'magentab', 'cyanb', 'whiteb'
      \   ],
      \ ],
      \ 'gitrebase': [
      \   [
      \      'pick','reword','edit','squash','fixup','exec'
      \   ],
      \ ],
    \ }

if has("autocmd")
  let g:lightline = { 'colorscheme': 'jellybeans' }
  let g:lightline.mode_map = {
        \ 'n':      '',
        \ 'i':      'INSERT',
        \ 'R':      'REPLACE',
        \ 'v':      'VISUAL',
        \ 'V':      'V-LINE',
        \ 'c':      'COMMAND',
        \ "\<C-v>": 'V-BLOCK',
        \ 's':      'SELECT',
        \ 'S':      'S-LINE',
        \ "\<C-s>": 'S-BLOCK',
        \ '?':      '      ' }
		let g:lightline.tabline = {
		    \ 'left':  [ [ 'tabs' ] ],
		    \ 'right': [ ] }
   		let g:lightline.active = {
		    \ 'left':  [ [ 'mode', 'paste' ],
		    \          [ 'readonly', 'relativepath', 'modified' ] ],
		    \ 'right': [ [ 'lineinfo' ],
		    \          [ 'fileformat', 'fileencoding', 'filetype' ] ] }
    let g:lightline.inactive = {
		    \ 'left':  [ [ 'relativepath' ] ],
		    \ 'right': [ [ 'lineinfo' ],
        \ ] }
  endif

" ycm, rip
" nnoremap <leader>yj :YcmCompleter GoTo<CR>
" nnoremap <leader>yr :YcmCompleter GoToReferences<CR>
" nnoremap <leader>yh :YcmCompleter GetDoc<CR>

" syntastic 
nmap <leader>sy :SyntastictoggleMode<cr>
nmap <leader>sl :SyntasticsetlocList<cr>:lw<cr>
nmap <leader>sj :JSContextColorToggle<cr>

" NrrwRgn
nnoremap <leader>nr :NR<CR>
vnoremap <leader>nr :NR<CR>

nmap <Leader>aa <Plug>(increment-activator-increment)
nmap <Leader>ax <Plug>(increment-activator-decrement)
nmap <c-a>      <Plug>(increment-activator-increment)
nmap <c-x>      <Plug>(increment-activator-decrement)

vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" fzf is so fucking amazing (yes, fucking)
nmap <Leader>gf :GFiles<CR>
nmap <Leader>gs :GFiles?<CR>
nmap <Leader>f :Files<CR>
nmap <Leader>t :Tags<CR>
nmap <Leader>l :Lines<CR>
nmap <Leader>bt :BTags<CR>
nmap <Leader>bl :BLines<CR>
nmap <Leader>bb :Buffers<CR>
nmap <Leader>k :Marks<CR>

" ripgrep-vim
nmap <Leader>rg :Rg<Space>

nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk
nmap <Leader>hs <Plug>GitGutterStageHunk
nmap <Leader>hu <Plug>GitGutterUndoHunk
nmap <Leader>hp <Plug>GitGutterPreviewHunk

nmap ]og :GitGutterLineHighlightsDisable<CR>
nmap [og :GitGutterLineHighlightsEnable<CR>

nmap ]gg :GitGutterDisable<CR>
nmap [gg :GitGutterEnable<CR>

nmap [gh :let g:gitgutter_diff_base = 'HEAD'<CR>
nmap [gm :let g:gitgutter_diff_base = 'origin/master'<CR>
nmap [gs :let g:gitgutter_diff_base = 'origin/staging'<CR>
