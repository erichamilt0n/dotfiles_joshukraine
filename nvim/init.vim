" Settings {{{
" NOTE: Some settings provided by vim-sensible.
" $XDG_DATA_HOME/nvim/plugged/vim-sensible/plugin/sensible.vim
" https://github.com/tpope/vim-sensible

" Disable netrw for nvim-tree
exe 'source' stdpath('config') . '/lua/netrw.lua'

" https://github.com/christoomey/vim-tmux-navigator/issues/72
set shell=/bin/bash\ -i

" Force vim to use older regex engine.
" https://stackoverflow.com/a/16920294/655204
set re=1

" set cmdheight=2

" No backup files
set nobackup

" No write backup
set nowritebackup

" No swap file
set noswapfile

" Show incomplete commands
set showcmd

" Ignore case in search if term(s) are lowercase
set ignorecase

" Search with case sensitivity if term(s) are upper or mixed case
set smartcase

" A buffer is marked as ‘hidden’ if it has unsaved changes, and it is not
" currently loaded in a window.
" If you try and quit Vim while there are hidden buffers, you will raise an
" error:
" E162: No write since last change for buffer “a.txt”
set hidden

" Turn word wrap off
set nowrap

" Don't break long lines in insert mode.
set formatoptions=l

" Convert tabs to spaces, all file types
set expandtab

" Set tab size in spaces (this is for manual indenting)
set tabstop=2

" The number of spaces inserted for a tab (used for auto indenting)
set shiftwidth=2

" Turn on line numbers AND use relative number
set number
set relativenumber

" Highlight tabs and trailing whitespace
set list listchars=tab:»·,trail:·,extends:>,precedes:<,nbsp:+

" UTF encoding
set encoding=utf-8

" Use system clipboard
" http://stackoverflow.com/questions/8134647/copy-and-paste-in-vim-via-keyboard-between-different-mac-terminals
set clipboard+=unnamed

" don't give |ins-completion-menu| messages.
set shortmess+=c

" Better splits (new windows appear below and to the right)
set splitbelow
set splitright

" Highlight the current line and column
set cursorline
" set cursorcolumn

" Ensure Vim doesn't beep at you every time you make a mistype
set visualbell

" redraw only when we need to (i.e. don't redraw when executing a macro)
set lazyredraw

" highlight a matching [{()}] when cursor is placed on start/end character
set showmatch

" Display the mode you're in.
" set showmode
set noshowmode " Or not...

" Complete files like a shell.
set wildmode=list:longest

" Show 2 lines of context around the cursor.
set scrolloff=2

" Set the terminal's title
set title

set tags=./tags;

" Vertical line at 80 characters
set textwidth=80
set colorcolumn=+1

" Start diff mode with vertical splits
set diffopt=vertical

" always show signcolumns
set signcolumn=auto

" Enable built-in matchit plugin
runtime macros/matchit.vim

set grepprg=rg

let g:grep_cmd_opts = '--line-numbers --noheading --ignore-dir=log --ignore-dir=tmp'

set inccommand=nosplit

set updatetime=300

" Keep focus split wide, others narrow.
set winwidth=90
set winminwidth=5

" Keep focus split at max height, others minimal.
set winheight=1
set winminheight=1
" The line below maximzes the window height on enter. Unfortunately it also
" maximizes the height of some floating windows. Disabling for now.
" autocmd WinEnter * wincmd _

" Requires 'jq' (brew install jq)
function! s:PrettyJSON()
  %!jq .
  set filetype=json
  normal zR
endfunction
command! PrettyJSON :call <sid>PrettyJSON()
" }}}

" Commands {{{
" specify syntax highlighting for specific files
augroup file_types
  autocmd!
  autocmd Bufread,BufNewFile *.asciidoc,*.adoc,*.asc,*.ad set filetype=asciidoctor
  autocmd Bufread,BufNewFile *.mdx set filetype=markdown
  autocmd Bufread,BufNewFile *.spv set filetype=php
  autocmd Bufread,BufNewFile *prettierrc,*stylelintrc,*babelrc,*eslintrc set filetype=json
  autocmd Bufread,BufNewFile aliases,functions,prompt,tmux,oh-my-zsh,opts set filetype=zsh
  autocmd Bufread,BufNewFile gitconfig set filetype=gitconfig
augroup END

" Remove trailing whitespace on save for specified file types.
augroup clear_whitespace
  autocmd!
  au BufWritePre *.rb,*.yml,*.erb,*.haml,*.css,*.scss,*.js,*.coffee,*.vue :%s/\s\+$//e
augroup END

" Fold settings
augroup fold_settings
  autocmd!
  autocmd FileType json setlocal foldmethod=syntax
  autocmd FileType json normal zR
augroup END

" automatically rebalance windows on vim resize
augroup window_resize
  autocmd!
  autocmd VimResized * :wincmd =
augroup END

" https://github.com/reedes/vim-textobj-quote#configuration
augroup textobj_quote
  autocmd!
  autocmd FileType markdown call textobj#quote#init()
  autocmd FileType textile call textobj#quote#init()
  autocmd FileType text call textobj#quote#init({'educate': 0})
augroup END

" }}}

" Mappings {{{
let mapleader = "\<Space>"

" Misc
nnoremap <leader>r :source $XDG_CONFIG_HOME/nvim/init.vim<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>x :x<CR>
nnoremap <leader>ra :%s/
nnoremap <leader>h :nohl<CR> " Clear highlights
nnoremap <leader>s :%s/\s\+$//e<CR> " Manually clear trailing whitespace
inoremap jj <C-c> " jj to switch back to normal mode
nnoremap <C-t> <esc>:tabnew<CR> " Open a new tab with Ctrl+T
nnoremap <leader>cc :set cursorcolumn!<CR>
nnoremap <leader>cl :set cursorline!<CR>

" Numeric leaders
nnoremap <leader>1 :set wrap<CR>
nnoremap <leader>2 :set nowrap<CR>
nnoremap <leader>3 :NvimTreeToggle<CR>
nnoremap <leader>4 <c-^> " Switch between the last two files
nnoremap <leader>5 :bnext<CR>
nnoremap <leader>6 :bprev<CR>

" Disable Ex mode
nnoremap Q <Nop>

" Move tabs left/right
noremap <A-Left>  :-tabmove<cr>
noremap <A-Right> :+tabmove<cr>

" Expand active file directory
cnoremap <expr> %%  getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Delete all lines beginning with '#' regardless of leading space.
nnoremap <leader>d :g/^\s*#.*/d<CR>:nohl<CR>

" Run 'git blame' on a selection of code
vnoremap <leader>gb :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" zoom a vim pane like in tmux
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>

" Adjust split size incrementally
nnoremap <Up> :resize +2<CR>
nnoremap <Down> :resize -2<CR>
nnoremap <Left> :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

" zoom back out
nnoremap <leader>= :wincmd =<cr>

" Maximize the height of the current window.
nnoremap <leader>0 :wincmd _<cr>

" Write files as sudo
cmap w!! w !sudo tee >/dev/null %
" }}}

" Plugins {{{
let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
if !filereadable(autoload_plug_path)
  silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs
        \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  autocmd VimEnter * PlugInstall --sync | exe 'source' stdpath('config') . '/init.vim'
endif
unlet autoload_plug_path

call plug#begin(stdpath('data') . '/plugged')

" General
Plug 'godlygeek/tabular'                " Vim script for text filtering and alignment           | https://github.com/godlygeek/tabular
Plug 'tomtom/tcomment_vim'              " An extensible & universal comment vim-plugin          | https://github.com/tomtom/tcomment_vim
Plug 'vim-scripts/BufOnly.vim'          " Delete all the buffers except current/named buffer    | https://github.com/vim-scripts/BufOnly.vim
Plug 'jlanzarotta/bufexplorer'          " Open/close/navigate vim's buffers                     | https://github.com/jlanzarotta/bufexplorer
Plug 'majutsushi/tagbar'                " A class outline viewer for vim                        | https://github.com/majutsushi/tagbar
Plug 'ntpeters/vim-better-whitespace'   " Better whitespace highlighting for                    | https://github.com/ntpeters/vim-better-whitespace
Plug 'machakann/vim-highlightedyank'    " Make the yanked region apparent!                      | https://github.com/machakann/vim-highlightedyank
Plug 'diepm/vim-rest-console'           " A REST console for Vim.                               | https://github.com/diepm/vim-rest-console
Plug 'rhysd/git-messenger.vim'          " Reveal the commit messages under the cursor           | https://github.com/rhysd/git-messenger.vim
Plug 'mg979/vim-visual-multi', {'branch': 'master'} " Multiple cursors plugin for vim/neovim    | https://github.com/mg979/vim-visual-multi
Plug 'airblade/vim-gitgutter'           " A Vim plugin which shows a git diff in the gutter     | https://github.com/airblade/vim-gitgutter
Plug 'reedes/vim-textobj-quote'         " Use ‘curly’ quote characters in Vim                   | https://github.com/reedes/vim-textobj-quote
Plug 'norcalli/nvim-colorizer.lua'      " The fastest Neovim colorizer.                         | https://github.com/norcalli/nvim-colorizer.lua

" Code Completion & Linting
Plug 'neoclide/coc.nvim',
      \ {'branch': 'release'}                         " Intellisense engine for vim8 & neovim   | https://github.com/neoclide/coc.nvim
Plug 'dense-analysis/ale'                             " Asynchronous Lint Engine                | https://github.com/dense-analysis/ale
Plug 'sdras/vue-vscode-snippets'                      " Vue VSCode Snippets                     | https://github.com/sdras/vue-vscode-snippets
Plug 'mattn/emmet-vim'                                " emmet for vim                           | https://github.com/mattn/emmet-vim
Plug 'joshukraine/vscode-es7-javascript-react-snippets',
      \ { 'do': 'yarn install --frozen-lockfile && yarn compile' } " React VSCode snippets      | https://github.com/joshukraine/vscode-es7-javascript-react-snippets

" Ruby-specific
Plug 'vim-ruby/vim-ruby'                " Vim/Ruby Configuration Files                          | https://github.com/vim-ruby/vim-ruby
Plug 'kana/vim-textobj-user'            " Create your own text objects                          | https://github.com/kana/vim-textobj-user
Plug 'nelstrom/vim-textobj-rubyblock'   " A custom text object for selecting ruby blocks        | https://github.com/nelstrom/vim-textobj-rubyblock

" Searching and Navigation
Plug 'junegunn/fzf', { 'do': './install --bin' } " A command-line fuzzy finder                  | https://github.com/junegunn/fzf
Plug 'junegunn/fzf.vim'                 " FZF for Vim                                           | https://github.com/junegunn/fzf.vim
Plug 'nvim-tree/nvim-web-devicons'      " File icons for nvim-tree                              | https://github.com/nvim-tree/nvim-web-devicons
Plug 'nvim-tree/nvim-tree.lua'          " A file explorer tree for neovim written in lua        | https://github.com/nvim-tree/nvim-tree.lua
Plug 'brooth/far.vim'                   " Find And Replace Vim plugin                           | https://github.com/brooth/far.vim
Plug 'christoomey/vim-tmux-navigator'   " Seamless navigation between tmux panes and vim splits | https://github.com/christoomey/vim-tmux-navigator
Plug 'easymotion/vim-easymotion'        " Vim motions on speed!                                 | https://github.com/easymotion/vim-easymotion
Plug 'ryanoasis/vim-devicons'           " Adds file type icons to Vim                           | https://github.com/ryanoasis/vim-devicons
Plug 'itchyny/lightline.vim'            " Light/configurable statusline/tabline plugin for Vim  | https://github.com/itchyny/lightline.vim

" Colorschemes
Plug 'icymind/NeoSolarized'             " Solarized colorscheme with better truecolor support   | https://github.com/icymind/NeoSolarized
Plug 'haishanh/night-owl.vim'           " Vim colorscheme based on sdras/night-owl-vscode-theme | https://github.com/haishanh/night-owl.vim
Plug 'kaicataldo/material.vim'          " A port of the Material color scheme for Vim/Neovim    | https://github.com/kaicataldo/material.vim
Plug 'rakr/vim-one'                     " Adaptation of Atom One colorscheme for Vim            | https://github.com/rakr/vim-one
Plug 'bluz71/vim-nightfly-guicolors'    " Another dark color scheme for Vim                     | https://github.com/bluz71/vim-nightfly-guicolors
Plug 'sonph/onehalf', {'rtp': 'vim/'}   " A colorscheme for (Neo)Vim, iTerm, and more.          | https://github.com/sonph/onehalf
Plug 'arcticicestudio/nord-vim'         " Vim colorscheme based on the Nord color palette       | https://github.com/arcticicestudio/nord-vim
Plug 'joshukraine/oceanic-next',
      \ {'branch': 'js/color-tweaks'}   " Oceanic Next theme for neovim                         | https://github.com/joshukraine/oceanic-next
Plug 'jacoborus/tender.vim'             " A 24bit colorscheme for Vim, Airline and Lightline    | https://github.com/jacoborus/tender.vim
Plug 'morhetz/gruvbox'                  " Retro groove color scheme for Vim                     | https://github.com/morhetz/gruvbox
Plug 'joshukraine/vim-monokai-tasty',   " My fork of patstockwell/vim-monokai-tasty             | https://github.com/joshukraine/vim-monokai-tasty

" Syntax Highlighting
Plug 'hail2u/vim-css3-syntax'           " CSS3 syntax                                           | https://github.com/hail2u/vim-css3-syntax
Plug 'cakebaker/scss-syntax.vim'        " Vim syntax file for scss (Sassy CSS)                  | https://github.com/cakebaker/scss-syntax.vim
Plug 'pangloss/vim-javascript',
      \ { 'for': ['javascript', 'vue']
      \}                                " Javascript indentation and syntax support in Vim.     | https://github.com/pangloss/vim-javascript
Plug 'maxmellon/vim-jsx-pretty'         " JSX and TSX syntax pretty highlighting for vim.       | https://github.com/MaxMEllon/vim-jsx-pretty
Plug 'posva/vim-vue'                    " Syntax Highlight for Vue.js components                | https://github.com/posva/vim-vue
Plug 'elzr/vim-json'                    " A better JSON for Vim                                 | https://github.com/elzr/vim-json
Plug 'digitaltoad/vim-pug'              " Vim syntax highlighting for Pug templates             | https://github.com/digitaltoad/vim-pug
Plug 'habamax/vim-asciidoctor'          " Asciidoctor plugin for Vim                            | https://github.com/habamax/vim-asciidoctor
Plug 'dag/vim-fish'                     " Vim support for editing fish scripts                  | https://github.com/dag/vim-fish
Plug 'cespare/vim-toml'                 " Vim syntax for TOML                                   | https://github.com/cespare/vim-toml
Plug 'leafgarland/typescript-vim'       " Typescript syntax files for Vim                       | https://github.com/leafgarland/typescript-vim
Plug 'Yggdroot/indentLine'              " Display indention levels with thin vertical lines     | https://github.com/Yggdroot/indentLine
Plug 'jparise/vim-graphql'              " GraphQL file detection, syntax highlighting, ...      | https://github.com/jparise/vim-graphql
Plug 'styled-components/vim-styled-components',
      \ { 'branch': 'main' }            " Vim bundle for styled components                      | https://github.com/styled-components/vim-styled-components
Plug 'iloginow/vim-stylus'              " Stylus syntax highlighting                            | https://github.com/iloginow/vim-stylus

" Tim Pope
Plug 'tpope/vim-surround'               " Quoting/parenthesizing made simple                    | https://github.com/tpope/vim-surround
Plug 'tpope/vim-rails'                  " Ruby on Rails power tools                             | https://github.com/tpope/vim-rails
Plug 'tpope/vim-obsession'              " Continuously updated session files                    | https://github.com/tpope/vim-obsession
Plug 'tpope/vim-fugitive'               " Tim Pope's Git wrapper                                | https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-repeat'                 " Enable repeating supported plugin maps with '.'       | https://github.com/tpope/vim-repeat
Plug 'tpope/vim-sensible'               " Defaults everyone can agree on                        | https://github.com/tpope/vim-sensible

" Testing & Tmux
Plug 'janko/vim-test'                   " Run your tests at the speed of thought                | https://github.com/janko/vim-test
Plug 'christoomey/vim-tmux-runner'      " Command runner for sending commands from vim to tmux. | https://github.com/christoomey/vim-tmux-runner

call plug#end()

" Plugin-specifc Mappings & Settings

" Far.vim
let g:far#source = 'rg'
let g:far#file_mask_favorites = ['%', '**/*.*', '**/*.html', '**/*.erb', '**/*.haml', '**/*.js', '**/*.css', '**/*.scss', '**/*.rb']

" nvim-tree
exe 'source' stdpath('config') . '/lua/nvim-tree-config.lua'
map <leader>\ :NvimTreeToggle<CR>
" Also see Numeric leaders above

" indentLine
let g:indentLine_char = '▏'

" vim-json
" https://github.com/Yggdroot/indentLine/issues/140#issuecomment-620465182
let g:vim_json_syntax_conceal = 0

" GitGutter
nnoremap <F6> :GitGutterToggle<CR>
nnoremap <F7> :GitGutterLineHighlightsToggle<CR>
let g:gitgutter_terminal_reports_focus=0
let g:gitgutter_preview_win_floating = 0
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'

nmap ]g <Plug>(GitGutterNextHunk)
nmap [g <Plug>(GitGutterPrevHunk)

" GitGutter default mapping reference
" https://github.com/airblade/vim-gitgutter#getting-started
" <leader>hp - Preview hunk
" <leader>hs - Stage hunk
" <leader>hu - Undo hunk

" GitMessenger
nmap <Leader>m <Plug>(git-messenger)

" Tcomment
map <leader>/ :TComment<CR>

" Bufexplorer
let g:bufExplorerDisableDefaultKeyMapping=1
nnoremap <silent> <F4> :BufExplorer<CR>

" Obsession
map <leader>ob :Obsession<CR>

" vim-textobj-quote
map <silent> <leader>rc <Plug>ReplaceWithCurly
map <silent> <leader>rs <Plug>ReplaceWithStraight

" vim-test
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
let test#strategy = 'vtr'

" vim-tmux-runner
let g:VtrPercentage = 25
let g:VtrUseVtrMaps = 0
nnoremap <leader>sd :VtrSendCtrlD<cr>
nmap <leader>fs :VtrFlushCommand<cr>:VtrSendCommandToRunner<cr>
nmap <leader>v3 :VtrAttachToPane 3<cr>
nmap <leader>v4 :VtrAttachToPane 4<cr>
nmap <leader>osp :VtrOpenRunner {'orientation': 'h', 'percentage': 25, 'cmd': '' }<cr>
nmap <leader>orc :VtrOpenRunner {'orientation': 'h', 'percentage': 40, 'cmd': 'rc'}<cr>
nmap <leader>opr :VtrOpenRunner {'orientation': 'h', 'percentage': 40, 'cmd': 'pry'}<cr>

" vim-tmux-runner default mappings
nnoremap <leader>va :VtrAttachToPane<cr>
" nnoremap <leader>ror :VtrReorientRunner<cr>
" nnoremap <leader>sc :VtrSendCommandToRunner<cr>
" nnoremap <leader>sl :VtrSendLinesToRunner<cr>
" vnoremap <leader>sl :VtrSendLinesToRunner<cr>
" nnoremap <leader>or :VtrOpenRunner<cr>
nnoremap <leader>kr :VtrKillRunner<cr>
nnoremap <leader>fr :VtrFocusRunner<cr>
" nnoremap <leader>dr :VtrDetachRunner<cr>
" nnoremap <leader>cr :VtrClearRunner<cr>
" nnoremap <leader>fc :VtrFlushCommand<cr>
" nnoremap <leader>sf :VtrSendFile<cr>

" indentLine
nnoremap <leader>it :IndentLinesToggle<CR>

" FZF
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>t :Files<CR>
nnoremap <leader>y :Rg<CR>

command! -bang -nargs=* Rg
      \ call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case --glob "!yarn.lock" '.shellescape(<q-args>), 1,
      \ fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" Custom rails.vim commands
" command! Rroutes :e config/routes.rb
" command! RTroutes :tabe config/routes.rb
" command! RSroutes :sp config/routes.rb
" command! RVroutes :vs config/routes.rb
" command! Rfactories :e spec/factories.rb
" command! RTfactories :tabe spec/factories.rb
" command! RSfactories :sp spec/factories.rb
" command! RVfactories :vs spec/factories.rb

" Key mappings for dragvisuals.vim
exe 'source' stdpath('config') . '/extras/dragvisuals.vim'

vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()

" Remove any introduced trailing whitespace after moving...
let g:DVB_TrimWS = 1

let g:user_emmet_leader_key=','

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Vim REST Console (VRC)
let g:vrc_curl_opts = {
      \ '-L': '',
      \ '-i': '',
      \ }

" ALE
let g:ale_disable_lsp = 1
let g:ale_fix_on_save = 0
let g:ale_linters_explicit = 1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '!!'

let g:ale_linters = {
\   'haml': ['hamllint'],
\   'eruby': ['erblint'],
\}

let g:ale_fixers = {
\   'eruby': ['erblint'],
\}

" Use `[a` and `]a` to navigate ALE diagnostics
" https://github.com/dense-analysis/ale/blob/a83a3659acd3c32c47cad85b7f996e178186732d/plugin/ale.vim#L292
nmap <silent> [a <Plug>(ale_previous)
nmap <silent> ]a <Plug>(ale_next)

" Coc
" https://github.com/neoclide/coc.nvim

" Global extension names to install when they aren't installed
let g:coc_global_extensions = [
      \ '@yaegassy/coc-tailwindcss3',
      \ '@yaegassy/coc-volar',
      \ '@yaegassy/coc-volar-tools',
      \ 'coc-css',
      \ 'coc-diagnostic',
      \ 'coc-emmet',
      \ 'coc-eslint',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-marketplace',
      \ 'coc-pairs',
      \ 'coc-prettier',
      \ 'coc-snippets',
      \ 'coc-solargraph',
      \ 'coc-stylelintplus',
      \ 'coc-tsserver',
      \ 'coc-yaml',
      \ ]

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"
" remap for complete to use tab and <cr>
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1):
    \ <SID>check_back_space() ? "\<Tab>" :
    \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()

hi CocSearch ctermfg=12 guifg=#18A3FF
hi CocMenuSel ctermbg=109 guibg=#13354A

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Comment highlighting for jsonc
autocmd FileType json syntax match Comment +\/\/.\+$+

" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Prettier
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

map <leader>p :Prettier<CR>
nnoremap <leader>cd :CocDisable<CR>
nnoremap <leader>ce :CocEnable<CR>
nnoremap <leader>cr :CocRestart<CR>

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
" nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" }}}

" Appearance {{{
exe 'source' "$DOTFILES/machines/$HOST_NAME/colorscheme.vim"
exe 'source' stdpath('config') . '/lightline.vim'

highlight clear IncSearch
highlight IncSearch term=reverse cterm=reverse ctermfg=7 ctermbg=0 guifg=Black guibg=White
highlight Comment cterm=italic gui=italic
" }}}

" Local {{{
if filereadable(glob("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif
" }}}

" vim: fdm=marker fen
