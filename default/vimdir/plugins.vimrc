" vi: ft=vim sts=2 ts=2 sw=2 et
"{{{1 Bootstrap
"{{{2 - require py
if !(has('python') || has('python3') || has('nvim'))
  echoerr 'no pythonsss'
  finish
endif

let s:is_windows = has('win32') || has('win64')

"{{{1 Plug defs
call plug#begin(rcz#VimrcDir() . '/plugged')

"{{{2 Plug defs
Plug 'ypcrts/securemodelines', { 'commit': 'fa69372a18cec61c664754848a7094fc4a866dcc' }
"Plug 'jamessan/vim-gnupg'
"Plug 'ypcrts/vim-gpg-sign'

Plug 'editorconfig/editorconfig-vim'
Plug      'Konfekt/FastFold'
Plug        'tpope/vim-eunuch'
Plug    'nishigori/increment-activator'
Plug        'tpope/vim-surround'
Plug        'tpope/vim-repeat'
Plug        'tpope/vim-endwise'
Plug        'tpope/vim-commentary'
Plug     'chrisbra/NrrwRgn', { 'on': ['NR', 'NarrowRegion'] }


" junegunn is everything
if s:is_windows
  Plug 'junegunn/fzf'  " XXX: for vim file, but scoop install fzf
else
  call rcz#PlugPathFirstOf('~/.fzf', '/usr/local/opt/fzf', )
endif
if has_key(g:plugs, '.fzf') || has_key(g:plugs, 'fzf')
  Plug 'junegunn/fzf.vim'
else
   echoerr 'y u no fzf? - ur vimz are sad'
   " Plug 'junegunn/fzf', { 'do': './install --bin'  }
 endif

Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/goyo.vim',      { 'on': 'Goyo' } " distraction-free mode
Plug 'junegunn/limelight.vim', { 'on': ['Goyo','Limelight'] }
Plug 'junegunn/gv.vim',        { 'on': 'GV' }
Plug 'junegunn/vim-journal',   { 'commit': '6ab162208dfc8fab479249e4d6a4901be2dabbe8' }

"{{{3 FZF alternatives - retired fuzzy finders
" You don't use these any more. You use fzf now.  [20190813T1934Z]
" Plug 'jremmen/vim-ripgrep' " deficient for splits
" Plug 'mileszs/ack.vim'     " just deficient

"{{{3 Git/VCS
Plug  'tpope/vim-fugitive'
Plug  'rhysd/git-messenger.vim'
Plug 'raghur/vim-ghost', has('nvim') ? { 'on': 'GhostStart' } : { 'on': [], 'for': [] }

"{{{3 Reading code
Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesEnable' }
  autocmd! User indentLine doautocmd indentLine Syntax
  let g:indentLine_color_term = 239
  let g:indentLine_color_gui = '#616161'

Plug 'mzlogin/vim-markdown-toc', { 'for': ['markdown'] }

"{{{3 Coc vs. alt_complete
if v:version >= 800 && has('nvim') && ! s:is_windows
  " Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
  " Plug 'iamcco/markdown-preview.nvim', { 'do': ':call mkdp#util#install()', 'for': 'markdown', 'on': 'MarkdownPreview' }
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
else
  Plug 'airblade/vim-gitgutter'
  Plug 'Chiel92/vim-autoformat'
  Plug 'ypcrts/vim-uncrustify', { 'for': ['c','cpp']  }

  if has('nvim') && ! s:is_windows
    Plug       'Shougo/deoplete.nvim',   { 'do': ':UpdateRemotePlugins' }
    Plug       'Shougo/neoinclude.vim'
    "Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
    " Plug        'zchee/deoplete-jedi',   { 'for': 'python' }
    " Plug 'tweekmonster/deoplete-clang2', { 'commit': '787dd4dc7eeb5d1bc2fd3cefcf7bd07e48f4a962' }
    " Plug     'carlitux/deoplete-ternjs', { 'for': 'javascript' }
    Plug       'wellle/tmux-complete.vim', s:is_windows ? { 'on': [], 'for': [] } : {}
  elseif v:version >= 703 && has('lua')
    Plug 'Shougo/neocomplete.vim'
  else
    " XXX: completion without lua?
    " Plug 'valloric/youcompleteme', {
    " \ 'do': 'echoerr \"You need to go compile YCM\"',
    " \ 'for': ['javascript']
    " \ }
  endif
endif


"{{{3 Linting: ale v. syntastic
if has('nvim') || v:version >= 800
  Plug 'dense-analysis/ale'
else
  Plug 'scrooloose/syntastic'
endif

" Plug 'heavenshell/vim-pydocstring', { 'for': 'python' }
"Plug     'fisadev/vim-isort', s:is_windows ? { 'on': [], 'for': [] } : { 'for': 'python' } " no work windows
Plug    'chrisbra/csv.vim',         { 'for':    'csv' }
"{{{2 network i/o (risk)
" Plug 'baverman/vial-http', { 'commit': 'NULL' } " cool rest client for vim
" XXX: TODO: blackmagic: cr ghost
Plug       'raghur/vim-ghost', has('nvim') ? { 'on': 'GhostStart' } : { 'on': [], 'for': [] }

"{{{3 Syntax
"{{{4 Syntax - polyglot and overrides
" note: polyglot disables plugin folder and only uses ftplugin, much breakage
"    rationale: optimize runtimes
"    fix: polyglot docs say to manually add them
" polyglot broken on nvim 0.3.0/sid
" let g:polyglot_disabled = ['markdown', 'autoindent']
" Plug 'sheerun/vim-polyglot'
"{{{4 Markdown
Plug  'godlygeek/tabular' " needed by markdown
Plug 'plasticboy/vim-markdown'

"{{{4 misc echosystems with esteroic, useless syntax
Plug 'ipkiss42/xwiki.vim', { 'for': 'xwiki', 'commit': '8551414062245924c870bd4049c166bab155f9f5' }

"{{{4 python ecosystems
" Plug 'tweekmonster/django-plus.vim'

"{{{4 rust ecosystems
Plug  'rust-lang/rust.vim',  { 'for': 'rust' }
Plug 'racer-rust/vim-racer', { 'for': 'rust' }
Plug    'cespare/vim-toml',  { 'for': 'toml' }
"{{{4 frontend or javascript ecosystems
Plug     'othree/html5.vim', { 'for': ['css','html'] }
Plug 'kevinoid/vim-jsonc', { 'for': 'jsonc' }
" Plug    'pangloss/vim-javascript',          { 'for': 'javascript' }
" Plug     'bigfish/vim-js-context-coloring', { 'commit': '6c90329664f3b0a58b05e2a5207c94da0d83a51c', 'for': 'javascript', 'do': 'echo "consider npm install --upgrade"' }
" this does not work for js files with syntax errors

" Plug 'digitaltoad/vim-jade',                { 'for': ['jade'] }
"{{{4 linux / systems
" Plug 'git://fedorapeople.org/home/fedora/wwoods/public_git/vim-scripts.git' "systemd
" Plug 'PotatoesMaster/i3-vim-syntax'
" Plug    'vim-scripts/bats.vim'
" Plug       'hashivim/vim-terraform'

"{{{4 esrever
Plug      'vim-scripts/AnsiEsc.vim'
Plug            'keith/swift.vim',        { 'for':    'swift'                                    }
" Plug 'CaledoniaProject/VIM-IDC'
" Plug           'alderz/smali-vim'
" Plug           'Shougo/vinarise.vim',  {'commit': '9285d3f0dc012c6bbe29210dc4f4628bb4ca5000' }  "hexeditor, abandoned
"{{{3 Folding
Plug           'ypcrts/vim-ini-fold',     { 'for':    ['gitignore','gitconfig','ini'],           'commit': 'b61a9ab242a316d2ba755c36c96888416162f1f4' }
Plug        'tmhedberg/SimpylFold',       { 'for':    'python',                                  'commit': 'aa0371d9d708388f3ba385ccc67a7504586a20d9' }
"{{{3 Colourschemes
Plug         'junegunn/seoul256.vim'
Plug           'tomasr/molokai'
Plug     'chriskempson/vim-tomorrow-theme'
Plug          'morhetz/gruvbox'
Plug           'yuttie/hydrangea-vim'
Plug 'tyrannicaltoucan/vim-deep-space'
Plug  'AlessandroYorba/Despacio'
Plug          'cocopon/iceberg.vim'
Plug       'nightsense/snow'
Plug       'nightsense/stellarized'
Plug  'arcticicestudio/nord-vim'
Plug       'nightsense/cosmic_latte'
Plug             'w0ng/vim-hybrid'
Plug         'nanotech/jellybeans.vim'
Plug             'guns/jellyx.vim'
Plug          'fisadev/fisa-vim-colorscheme'
Plug      'whatyouhide/vim-gotham'        ",   { 'commit': 'f46412d4f9768c332ae22676f3ef4cc130457ba0' }
Plug          'djjcast/mirodark',              { 'commit': '306c5f96dd0ecaa64eac603b990a22300dc798f7' }
" Plug         'lu-ren/SerialExperimentsLain', { 'commit': 'aabb800d6a27cde243604a94a9a14334286a87b2' }
Plug           'zcodes/vim-colors-basic',      { 'commit': 'bdf14db578ad283bffa019ab2236f4d378eef34b' }
Plug       'lifepillar/vim-solarized8'    ",   { 'commit': 'dc6c1dfa6f5c068ba338b8a2e4f88f4b6de4433a' }
Plug       'nightsense/snow'
" if !has('nvim') " nvim no work? 16-bit
"   Plug 'laserswald/chameleon.vim',   { 'commit': 'e7c9991fa19961dd2bcf89e92f09be1da89b8c77' }
" endif
" Plug 'nightsense/vim-crunchbang'
" Plug 'flazz/vim-colorschemes'
"{{{2 End of plugin definitions-------------------------------------------------------------------
"
call plug#end()

"}}}1
"{{{1 Reset to sane plugin defaults
"{{{2 can i haz no default maps pleaz
" This has it's own section now because when I see these lines unfolded I get
" grumpy, and the inconsistency between the meanings of the 1s and 0s is
" really next level. Vim 9 needs a plugin default mapping api, so you can turn
" them all off, forever.
let  g:gitgutter_map_keys                          = 0
let  g:pydocstring_enable_mapping                  = 0
let  g:nrrw_rgn_nomap_nr                           = 1
let  g:nrrw_rgn_nomap_Nr                           = 1
let  g:increment_activator_no_default_key_mappings = 1
let  g:js_context_colors_usemaps                   = 0

"{{{2 can i haz enable plugin
let                          g:gitgutter_enabled = 1
" let                    g:javascript_plugin_jsdoc = 1

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

"{{{1 Configure plugins
"{{{2 Coc vs. alt_complete - complete config
if has_key(g:plugs, 'coc.nvim')
  function! s:show_documentation()
    if (index(['vim', 'help'], &filetype) >= 0)
      execute 'h' expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  let g:coc_global_extensions = [
        \ 'coc-git'
        \ , 'coc-python', 'coc-html', 'coc-json', 'coc-css'
        \ , 'coc-prettier', 'coc-eslint', 'coc-tsserver', 'coc-emoji'
        \ ]
        ", 'coc-java'
        ", 'coc-r-lsp', 'coc-solargraph'
  command! -nargs=0 Prettier :CocCommand prettier.formatFile
  let g:go_doc_keywordprg_enabled = 0
  augroup coc-config
    autocmd!
    autocmd VimEnter * nmap <silent> <leader>gd <Plug>(coc-definition)
    autocmd VimEnter * nmap <silent> <leader>gi <Plug>(coc-implementation)
    autocmd VimEnter * nmap <silent> <leader>su <Plug>(coc-references)
  augroup END

  nmap <leader>rn <Plug>(coc-rename)
  xmap <leader>af <Plug>(coc-format-selected)
  nmap <leader>af <Plug>(coc-format-selected)
  nmap <leader>qf <Plug>(coc-format-selected)

  nnoremap ,c :CocList commands<cr>
  nmap <silent> [c <Plug>(coc-diagnostic-prev)
  nmap <silent> ]c <Plug>(coc-diagnostic-next)
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gr <Plug>(coc-references)

  inoremap <silent><expr>   <C-space> coc#refresh()
  inoremap <silent><expr>   <C-cr>    coc#refresh()
  inoremap <silent><expr>   <D-cr>    coc#refresh()

else
  :exe 'source' rcz#VimFileRealpath("alt_complete.vimrc")
endif
"{{{2 ale v. synastic - linter config
if has_key(g:plugs, 'ale')
  let g:ale_lint_on_text_changed = 'always'
  let g:ale_lint_on_enter = 0
  let g:ale_lint_delay = 1000
  let g:ale_sign_error = 'E'
  let g:ale_sign_warning = 'W'
  let g:ale_echo_cursor = 1
  let g:ale_echo_msg_format = '[%linter%] %severity%: %s'
  let g:ale_list_window_size = 6
  let g:ale_completion_enabled = 0
  let g:ale_linter_aliases = {
        \ 'javascript': ['javascript','typescript','json']
        \ }
  let g:ale_linters = {
        \ 'python': ['flake8'],
        \ 'c' : ['gcc-7'],
        \ 'json': ['prettier'],
        \ 'javascript': ['eslint'],
        \ 'typescript': ['tsserver','eslint']
        \ } " merged dict; no pylint in ale please
  let g:ale_fixers = {
        \ 'javascript': ['prettier', 'eslint'],
        \ 'typescript':  ['prettier', 'eslint'],
        \ }

  map <Leader>af :ALEFix<CR>
  nmap ]a <Plug(ale_next_wrap)
  nmap [a <Plug(ale__wrap)
else
  map <Leader>af :Autoformat<CR>
  " without ale, we use syntastic
  let g:syntastic_javascript_checkers = [ 'eslint' ]
  let g:syntastic_python_checkers = [ 'flake8', 'pylint' ]

  nmap <leader>sy :SyntastictoggleMode<cr>
  nmap <leader>sl :SyntasticsetlocList<cr>:lw<cr>
endif

if has_key(g:plugs, 'vim-js-context-coloring')
  let g:js_context_colors_enabled                  = 0
  let g:js_context_colors_highlight_function_names = 0

  nmap <leader>sj :JSContextColorToggle<cr>
endif

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
if $TERM =~ 'screen'
  nnoremap <C-a> <nop>
  nnoremap <Leader>aa <C-a>
endif


"{{{2 NrrwRgn
nnoremap <leader>nr :NR<CR>
vnoremap <leader>nr :NR<CR>

"{{{2 EasyAlign
xmap <Enter> <Plug>(EasyAlign)
nmap ga      <Plug>(EasyAlign)
xmap gA      <Plug>(LiveEasyAlign)

" space
nmap gas vip<ESC>:'<,'>EasyAlign */[ ]/l0r0<CR>

" vimpluginaligning easyalign vim-plug defs >_>
vmap gaga :'<,'>EasyAlign/[ /]/alrlig['Comment']l0r0<<CR>
nmap gaga vipgaga<ESC>

"{{{2 fzf (over rg and ag)
"""""""""""""""""""""""""""""""""""""
" https://github.com/junegunn/fzf.vim
" :GFiles  -> git files
" :GFiles? -> git status dirty files
" :BLines  -> lines in current buffer
"""""""""""""""""""""""""""""""""""""
let $FZF_DEFAULT_OPTS .= ' --inline-info'

if exists('$TMUX')
"  let g:fzf_layout = { 'tmux': '-p 60%,40%' }  " req tmux > 3.2
   let g:fzf_layout = { 'tmux': "-d 30%" }
else
  "let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
  let g:fzf_layout = { 'down': '~40%' }
endif
let g:fzf_prefer_tmux = 1
let g:fzf_buffers_jump = 1
let g:fzf_colors ={
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment']
      \ }

" Terminal buffer options for fzf
autocmd! FileType fzf
autocmd  FileType fzf set noshowmode noruler nonu
" nmap ,c :CocList commands<CR>
nmap ,e :Commands<CR>
nmap ,b :Buffers<CR>
nmap ,f :Files<CR>
nmap ,hi :History<CR>
nmap ,hi :History<CR>
nmap ,m :Maps<CR>
nmap ,gs :GFiles?<CR>
nmap ,gf :GFiles<CR>
nmap ,gg :GitGrep<CR>
nmap ,r  :Rg<CR>

" local lines in current buffer
nmap ,ll :BLines<CR>

" lines in all buffers
nmap ,lb :Lines<CR>
nmap ,p :Files ~/Projects<CR>
nmap ,t :Files ~/Projects<CR>

nmap <Leader>fg :GFiles<CR>
nmap <Leader>fs :GFiles?<CR>
nmap <Leader>fl :Lines<CR>
nmap <Leader>fb :BLines<CR>
nmap <Leader>ft :Tags<CR>

nmap <Leader>ag  :Ag<cr>
nmap <Leader>rg  :Rg<cr>
nmap <Leader>gg  :GitGrep<cr>
nmap <Leader>ff  :Files<CR>
nmap <Leader>fp  :Files ~/Projects<CR>

imap <C-x><C-f> <plug>(fzf-complete-path)
imap <C-x><C-z> <plug>(fzf-complete-line)

command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, fzf#vim#with_preview(),<bang>0)

command! -bang -nargs=* Rg call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=* GitGrep call fzf#vim#grep(
  \   'git grep --line-number  --color -- '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0], 'preview-window': 'up:60%'}),
  \   <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

"{{{2 coc-git
if has_key(g:plugs, 'coc.nvim')
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
nmap gi <Plug>(coc-git-chunkinfo)
nmap gs :CocCommand git.chunkStage<cr>
omap ig <Plug>(coc-git-chunk-inner)
xmap ig <Plug>(coc-git-chunk-inner)
omap ig <Plug>(coc-git-chunk-outer)
xmap ig <Plug>(coc-git-chunk-outer)
nmap <Leader>ogg :CocCommand git.toggleGutters<cr>

"{{{2 gitgutter   [:h gitgutter.txt]
elseif has_key(g:plugs, 'gitgutter')
  nmap <Leader>ogg :GitGutterToggle<CR>
  nmap [g         <Plug>(GitGutterPrevHunk)
  nmap ]g         <Plug>(GitGutterNextHunk)
  nmap gs <Plug>(GitGutterStageHunk)
  " nmap gu <Plug>(GitGutterUndoHunk)
  nmap gi <Plug>(GitGutterPreviewHunk)
  nmap ghh :GitGutterLineHighlightsToggle<CR>:set nu<CR>:GitGutterLineNrHighlightsToggle<CR>
endif

"{{{2 Commentary
map    gc           <Plug>Commentary
nmap   gcc          <Plug>CommentaryLine
map    <Leader>cc   <Plug>Commentary
nmap   <Leader>cc   <Plug>CommentaryLine

"{{{2 NERDTree
" let g:NERDTreeIgnore = ['\~$', '\.pyc$']
" nnoremap <Leader>nt :NERDTree<CR>
command! NERDTree echomsg "use :Vexplore or :Files"
