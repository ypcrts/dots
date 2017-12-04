" vi: ft=vim sts=2 ts=2 sw=2 et
"{{{1 bootstrap

"{{{2 i need pythons
if !(has('python') || has('python3') || has('nvim'))
  echoerr 'no pythonsss'
  finish
endif

call plug#begin(expand('<sfile>:p:h') . '/plugged')

let s:plugs = {}

"{{{2 plugs
Plug   'ypcrts/securemodelines', { 'commit': '33f695221cea4d965a47ab24a78fa2646c5e417e' }
" Plug 'jamessan/vim-gnupg'
" Plug   'ypcrts/vim-gpg-sign'

Plug 'editorconfig/editorconfig-vim'
Plug      'Konfekt/FastFold'
Plug        'tpope/vim-eunuch'
Plug      'itchyny/lightline.vim'
Plug    'nishigori/increment-activator'
Plug        'tpope/vim-surround'
Plug        'tpope/vim-repeat'
Plug   'scrooloose/nerdcommenter'
Plug   'scrooloose/nerdtree'
Plug     'chrisbra/NrrwRgn'

" I only have one fetish and it's junegunn's code.
Plug        '~/.fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/vim-easy-align'
" if has('nvim') || v:version >= 800
"   Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
" endif

"{{{3 fuzzy finders
" Plug 'jremmen/vim-ripgrep' " deficient for splits
Plug 'mileszs/ack.vim'


"{{{3 linting
if has('nvim') || v:version >= 800
  Plug 'w0rp/ale'
else
  Plug 'scrooloose/syntastic'
endif

Plug 'heavenshell/vim-pydocstring', { 'for': 'python' }
Plug     'fisadev/vim-isort',       { 'for': 'python' }
Plug    'chrisbra/csv.vim',         { 'for':    'csv' }

"{{{3 completion
if has('nvim')
  " deoplete does not work on vim8, stop hoping, cry
  Plug       'Shougo/deoplete.nvim',   { 'do': ':UpdateRemotePlugins' }
  Plug       'Shougo/neoinclude.vim'
  Plug        'zchee/deoplete-jedi',   { 'for': 'python' }
  Plug 'tweekmonster/deoplete-clang2', { 'commit': '787dd4dc7eeb5d1bc2fd3cefcf7bd07e48f4a962' }
  Plug     'carlitux/deoplete-ternjs', { 'for': 'javascript' }
  Plug       'wellle/tmux-complete.vim'
elseif v:version >= 703 && has('lua')
  Plug 'Shougo/neocomplete.vim'
else
  " TODO: completion without lua?
  " Plug 'valloric/youcompleteme', {
  " \ 'do': 'echoerr \"You need to go compile YCM\"',
  " \ 'for': ['javascript']
  " \ }
endif

Plug   'mattn/emmet-vim'
Plug 'Chiel92/vim-autoformat'
" Plug 'python-rope/ropevim', { 'for': 'python' }
" Plug 'ypcrts/vim-uncrustify', { 'for': ['c','cpp']  }


"{{{3 Syntax
"{{{4 metapackages
" Plug 'sheerun/vim-polyglot' " 6d6574617061636b616765207365637572697479207269736b206666730a
"{{{4 python ecosystems
" TODO: FIXME FIXME FIXME DAD FIXME FIXME
Plug            '~/Projects/ansible-vim', { 'branch': 'j2-commentstring' }
Plug 'tweekmonster/django-plus.vim'

"{{{4 rust ecosystems
Plug   'rust-lang/rust.vim',                { 'for': 'rust' }
Plug  'racer-rust/vim-racer',               { 'for': 'rust' }
Plug     'cespare/vim-toml',                { 'for': 'toml' }
"{{{4 javascript ecosystems
" Plug    'pangloss/vim-javascript',          { 'for': 'javascript' }
" Plug     'bigfish/vim-js-context-coloring', { 'commit': '6c90329664f3b0a58b05e2a5207c94da0d83a51c', 'for': 'javascript', 'do': 'nvm use 6 && npm install --upgrade' }
" Plug 'digitaltoad/vim-jade',                { 'for': ['jade'] }
"{{{5 linux / systems
" Plug 'git://fedorapeople.org/home/fedora/wwoods/public_git/vim-scripts.git' "systemd
" Plug 'PotatoesMaster/i3-vim-syntax'
Plug    'vim-scripts/bats.vim'
Plug       'hashivim/vim-terraform'

"{{{4 esrever
" Plug 'CaledoniaProject/VIM-IDC'
" Plug           'alderz/smali-vim'
Plug           'Shougo/vinarise.vim'
"{{{3 Folding
Plug           'ypcrts/vim-ini-fold', { 'commit': 'b61a9ab242a316d2ba755c36c96888416162f1f4', 'for': ['gitignore','gitconfig','ini'] }
Plug        'tmhedberg/SimpylFold',   { 'for': 'python', 'commit': 'aa0371d9d708388f3ba385ccc67a7504586a20d9' }
"{{{3 Git/VCS
Plug         'airblade/vim-gitgutter'
Plug            'tpope/vim-fugitive'

"{{{4 Gist-vim
" TODO: cr die webapi-vim neuigkeiten, scheiße
Plug 'mattn/gist-vim',   { 'commit': 'f0d63579eab7548cf12f979dc52ef5a370ecbe63' }
Plug 'mattn/webapi-vim', { 'commit': 'e3fa93f29a3a0754204002775e140d8a9acfd7fd' }
" Plug 'baverman/vial-http', { 'commit': 'NULL' }

"{{{3 Colourschemes
Plug        'w0ng/vim-hybrid'
Plug    'nanotech/jellybeans.vim'
Plug        'guns/jellyx.vim'
Plug     'fisadev/fisa-vim-colorscheme'
Plug 'whatyouhide/vim-gotham'             ",      { 'commit': 'f46412d4f9768c332ae22676f3ef4cc130457ba0' }
Plug     'djjcast/mirodark',              { 'commit': '306c5f96dd0ecaa64eac603b990a22300dc798f7' }
Plug      'lu-ren/SerialExperimentsLain', { 'commit': 'aabb800d6a27cde243604a94a9a14334286a87b2' }
Plug      'zcodes/vim-colors-basic',      { 'commit': 'bdf14db578ad283bffa019ab2236f4d378eef34b' }
Plug  'lifepillar/vim-solarized8'         ",    { 'commit': 'dc6c1dfa6f5c068ba338b8a2e4f88f4b6de4433a' }

if !has('nvim') " nvim no work? 16-bit
  Plug 'laserswald/chameleon.vim',   { 'commit': 'e7c9991fa19961dd2bcf89e92f09be1da89b8c77' }
endif
" Plug 'nightsense/vim-crunchbang'
" Plug 'flazz/vim-colorschemes'

call plug#end()
"}}}1
"{{{1 trash
"{{{2 can i haz no default fucking maps pleaz
" This has it's own section now because when I see these lines unfolded I get
" grumpy, and the inconsistency between the meanings of the 1s and 0s is
" really next level. Vim 9 needs a plugin default mapping api, so you can turn
" them all off, forever.
let g:gitgutter_map_keys = 0
let g:pydocstring_enable_mapping = 0
let g:nrrw_rgn_nomap_nr = 1
let g:nrrw_rgn_nomap_Nr = 1
let g:increment_activator_no_default_key_mappings = 1
let g:js_context_colors_usemaps = 0

"{{{2 can i haz enable plugin
let g:gitgutter_enabled = 1
let g:js_context_colors_enabled = 0
let g:js_context_colors_highlight_function_names = 0
let g:javascript_plugin_jsdoc = 1

"{{{1 configuration
"{{{2 completion plugin
if has_key(s:plugs, 'deoplete.nvim')
  let g:deoplete#enable_at_startup = 1

elseif has_key(s:plugs, 'neocomplete.vim') "{{{4

  " defaults pasted here

  "Note: This option must be set in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
  " Disable AutoComplPop.
  let g:acp_enableAtStartup = 0
  " Use neocomplete.
  let g:neocomplete#enable_at_startup = 1
  " Use smartcase.
  let g:neocomplete#enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3

  " Define dictionary.
  let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'

  " Plugin key-mappings.
  " inoremap <expr><C-g>     neocomplete#undo_completion()
  " inoremap <expr><C-l>     neocomplete#complete_common_string()

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
    " For no inserting <CR> key.
    "return pumvisible() ? "\<C-y>" : "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  " Close popup by <Space>.
  "inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

  " AutoComplPop like behavior.
  "let g:neocomplete#enable_auto_select = 1

  " Shell like behavior(not recommended).
  "set completeopt+=longest
  "let g:neocomplete#enable_auto_select = 1
  "let g:neocomplete#disable_auto_complete = 1
  "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

  " Enable heavy omni completion.
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
  "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

  " For perlomni.vim setting.
  " https://github.com/c9s/perlomni.vim
  let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
  "}}}4
elseif has_key(s:plugs, 'youcompleteme') "{{{4
  let g:ycm_key_invoke_complete = '' "<C-Space> === <NUL>
  let g:ycm_key_detailed_diagnostics = '<leader>yd'
  let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<C-n>']
  let g:ycm_autoclose_preview_window_after_completion = 1
  let g:ycm_autoclose_preview_window_after_insertion  = 1
  let g:ycm_semantic_triggers =  {
        \   'c' : ['->', '.'],
        \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
        \             're!\[.*\]\s'],
        \   'ocaml' : ['.', '#'],
        \   'cpp,objcpp' : ['->', '.', '::'],
        \   'perl' : ['->'],
        \   'php' : ['->', '::'],
        \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
        \   'python' : ['.', 'from ', 'import '],
        \   'ruby' : ['.', '::'],
        \   'lua' : ['.', ':'],
        \   'erlang' : [':'],
        \ }
  nnoremap <leader>yj :YcmCompleter GoTo<CR>
  nnoremap <leader>yr :YcmCompleter GoToReferences<CR>
  nnoremap <leader>yh :YcmCompleter GetDoc<CR>
  "}}}4
endif

"{{{2 linter
if has_key(s:plugs, 'ale')
  let g:ale_lint_on_text_changed = 'always'
  let g:ale_lint_on_enter = 0
  let g:ale_lint_delay = 5000
  let g:ale_sign_error = 'E'
  let g:ale_sign_warning = 'W'
  let g:ale_echo_cursor = 1
  let g:ale_echo_msg_format = '[%linter%] %severity%: %s'
  let g:ale_list_window_size = 6
  let g:ale_completion_enabled = 0
  let g:ale_linters = { 'python': ['flake8', 'pylint'],
        \ 'c' : ['gcc-7']
        \ } " merged dict; no pylint in ale please

elseif has_key(s:plugs, 'syntastic')

  let g:syntastic_javascript_checkers = [ 'eslint' ]
  let g:syntastic_python_checkers = [ 'flake8', 'pylint' ]

  nmap <leader>sy :SyntastictoggleMode<cr>
  nmap <leader>sl :SyntasticsetlocList<cr>:lw<cr>

  "This has nothing to do with syntastic, but i use them together <- lie
  nmap <leader>sj :JSContextColorToggle<cr>
endif

"{{{2 lightline
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

"{{{2 increment-activator
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
nmap <Leader>aa <Plug>(increment-activator-increment)
nmap <Leader>ax <Plug>(increment-activator-decrement)
nmap <c-a>      <Plug>(increment-activator-increment)
nmap <c-x>      <Plug>(increment-activator-decrement)


"{{{2 NrrwRgn
nnoremap <leader>nr :NR<CR>
vnoremap <leader>nr :NR<CR>

"{{{2 EasyAlign
vmap <Enter> <Plug>(EasyAlign)
nmap ga      <Plug>(EasyAlign)
nmap gaga    vip<Esc>:'<,'>EasyAlign /[ /]/alrlig['Comment']stl1l0r0<CR>
nmap gas     vip<Esc>:'<,'>EasyAlign */[ ]/l0r0<CR>

"{{{2 fzf & ripgrep
nmap <Leader>fg  :GFiles<CR>
nmap <Leader>fs  :GFiles?<CR>
nmap <Leader>ff  :Files<CR>
nmap <Leader>fl  :Lines<CR>
nmap <Leader>flb :BLines<CR>
nmap <Leader>fb  :Buffers<CR>
nmap <Leader>ft  :Tags<CR>
nmap <Leader>rg  :Rg!<cr>

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

"{{{2 gitgutter
nmap [h         <Plug>GitGutterPrevHunk
nmap ]h         <Plug>GitGutterNextHunk
nmap <Leader>hs <Plug>GitGutterStageHunk
nmap <Leader>hu <Plug>GitGutterUndoHunk
nmap <Leader>hp <Plug>GitGutterPreviewHunk

nmap <Leader>ogg :GitGutterToggle<CR>
nmap <Leader>hh  :GitGutterLineHighlightsToggle<CR>

nmap <Leader>ggb :let g:gitgutter_diff_base =
nmap <Leader>ggh :let g:gitgutter_diff_base = 'HEAD'<CR>
nmap <Leader>ggm :let g:gitgutter_diff_base = 'origin/master'<CR>
nmap <Leader>ggs :let g:gitgutter_diff_base = 'origin/staging'<CR>

"{{{2 NERDCommenter
let g:NERDSpaceDelims=1
let g:NERDRemoveExtraSpaces=1
let g:NERDCompactSexyComs=0
" vim 8 / neovim HEAD runtime: when ft==python, cms:=#\ %s
"   -- when g:NERDSpaceDelims==1, then NERDComment results in double space
let g:NERDCustomDelimiters = {
      \ 'python': { 'left': '#', 'right': '' }
      \ }
let g:NERDTrimTrailingWhitespace=1

"{{{2 NERDTree
let g:NERDTreeIgnore = ['\~$', '\.pyc$']
nnoremap <Leader>nt :NERDTree<CR>

"{{{2 whut - trash? - replace with your own less trash, but still trash?
"          - or stop whining and contribute?  [ypcrts // 20170914T2058Z]
nmap <Leader>af :Autoformat<CR>
vmap <Leader>af :Autoformat<CR>