
" ===
" === Auto load for first time uses
" ===
if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


" ===
" === Create a _machine_specific.vim file to adjust machine specific stuff, like python interpreter location
" ===
let has_machine_specific_file = 1
if empty(glob('~/.config/nvim/_machine_specific.vim'))
	let has_machine_specific_file = 0
	silent! exec "!cp ~/.config/nvim/default_configs/_machine_specific_default.vim ~/.config/nvim/_machine_specific.vim"
endif
source $HOME/.config/nvim/_machine_specific.vim


" ====================
" === Editor Setup ===
" ====================

set nocompatible
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
set mouse=a
set encoding=utf-8
let &t_ut=''
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set list
set listchars=tab:▸\ ,trail:▫
set scrolloff=9
set tw=0
set indentexpr=
set backspace=indent,eol,start
set foldmethod=indent
set foldlevel=99
set laststatus=2
set autochdir
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

let mapleader=" "
syntax on
set number
set relativenumber
set wrap
set showcmd
set wildmenu
set hlsearch
exec "nohlsearch"
set incsearch
set ignorecase
set smartcase

silent !mkdir -p ~/.config/nvim/tmp/backup
silent !mkdir -p ~/.config/nvim/tmp/undo
"silent !mkdir -p ~/.config/nvim/tmp/sessions
set backupdir=~/.config/nvim/tmp/backup,.
set directory=~/.config/nvim/tmp/backup,.
if has('persistent_undo')
	set undofile
	set undodir=~/.config/nvim/tmp/undo,.
endif
set colorcolumn=100
set updatetime=1000
set virtualedit=block

noremap j h
noremap k j
noremap i k
noremap I 5k
noremap K 5j
noremap J 7h
noremap L 7l
noremap <C-j> 0
noremap <C-l> $
noremap h i
noremap H I

noremap n nzz
noremap N Nzz
noremap <LEADER><CR> :nohlsearch<CR>
map S :w<CR>
map Q :q<CR>
map R :source $MYVIMRC<CR>
map ; :

map zl :set splitright<CR>:vsplit<CR>
map zj :set nosplitright<CR>:vsplit<CR>
map zi :set nosplitbelow<CR>:split<CR>
map zk :set splitbelow<CR>:split<CR>
map za <C-w>t<C-w>K
map zx <C-w>t<C-w>H
map <LEADER>j <C-w>h
map <LEADER>l <C-w>l
map <LEADER>i <C-w>k
map <LEADER>k <C-w>j
map <up> :res +5<CR>
map <down> :res -5<CR>
map <left> :vertical resize-5<CR>
map <right> :vertical resize+5<CR>
map <Tab><CR> :tabe<CR>
map <Tab>j :-tabnext<CR>
map <Tab>l :+tabnext<CR>

" Open the vimrc file anytime
noremap <LEADER>rc :set splitright<CR>:vsplit<CR>:e ~/.config/nvim/init.vim<CR>

" Indentation
nnoremap < <<
nnoremap > >>

" Adjacent duplicate words
noremap <LEADER>dw /\(\<\w\+\>\)\_s*\1

" Space to Tab
nnoremap <LEADER>tt :%s/    /\t/g
vnoremap <LEADER>tt :s/    /\t/g

" ===
" === Insert Mode Cursor Movement
" ===
inoremap <C-a> <ESC>A

" ===
" === Markdown Settings
" ===
" Snippets
 source ~/.config/nvim/md-snippets.vim
" auto spell
autocmd BufRead,BufNewFile *.md setlocal spell

" Opening a terminal window
noremap <LEADER>/ :set splitbelow<CR>:split<CR>:res +10<CR>:term<CR>

" Spelling Check with <space>sc
noremap <LEADER>sc :set spell!<CR>

" press f10 to show hlgroup
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Compile function
noremap r :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		set splitbelow
		exec "!g++ -std=c++11 % -Wall -o %<"
		:sp
		:res -15
		:term ./%<
	elseif &filetype == 'java'
		exec "!javac %"
		exec "!time java %<"
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		set splitbelow
		:sp
		:term python3 %
	elseif &filetype == 'html'
		silent! exec "!".g:mkdp_browser." % &"
	elseif &filetype == 'markdown'
		exec "MarkdownPreview"
	elseif &filetype == 'tex'
		silent! exec "VimtexStop"
		silent! exec "VimtexCompile"
	elseif &filetype == 'dart'
		exec "CocCommand flutter.run -d ".g:flutter_default_device
		CocCommand flutter.dev.openDevLog
	elseif &filetype == 'javascript'
		set splitbelow
		:sp
		:term export DEBUG="INFO,ERROR,WARNING"; node --trace-warnings .
	elseif &filetype == 'go'
		set splitbelow
		:sp
		:term go run .
	endif
endfunc


" ===
" === Install Plugins with Vim-Plug
" ===

call plug#begin('~/.config/nvim/plugged')

" Pretty Dress
Plug 'bling/vim-bufferline'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dracula/vim'

Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}
" 批注插件
Plug 'scrooloose/nerdcommenter' " in <space>cc to comment a line
" cs替换包裹字符
Plug 'tpope/vim-surround' " type yskw' to wrap the word with '' or type cs'` to change 'word' to `word`
" 反义词替换 如 True <--> False
Plug 'jwarby/antovim' " gs to switch
" 文本对齐
Plug 'godlygeek/tabular' " ga, or :Tabularize <regex> to align

" 选中相同文本 <C-d>
Plug 'mg979/vim-visual-multi'

" Auto Complete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'wellle/tmux-complete.vim'

" Go
Plug 'fatih/vim-go' , { 'for': ['go', 'vim-plug'], 'tag': '*' }

" Python
" 缩进
" Plug 'tmhedberg/SimpylFold', { 'for' :['python', 'vim-plug'] }
Plug 'Vimjas/vim-python-pep8-indent', { 'for' :['python', 'vim-plug'] }
" 函数中高亮变量、重命名变量
" :semshi rename ...
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins', 'for' :['python', 'vim-plug'] }
" 函数列表 Taglist
" Plug 'majutsushi/tagbar', { 'on': 'TagbarOpenAutoClose' }
Plug 'liuchengxu/vista.vim'

" 查找替换 Find & Replace
Plug 'brooth/far.vim', { 'on': ['F', 'Far', 'Fardo'] }

" 查看修改历史记录 Undo Tree
Plug 'mbbill/undotree'
" 查找当前目录文件
Plug 'junegunn/fzf.vim'
" Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" 书签 Bookmarks
Plug 'kshenoy/vim-signature'


" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install_sync() }, 'for' :['markdown', 'vim-plug'] }
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle', 'for': ['text', 'markdown', 'vim-plug'] }
Plug 'mzlogin/vim-markdown-toc', { 'for': ['gitignore', 'markdown', 'vim-plug'] }
Plug 'dkarter/bullets.vim'

" 进入vim时可以选择文件
Plug 'mhinz/vim-startify'

" Other useful utilities
Plug 'lambdalisue/suda.vim' " do stuff like :sudowrite
Plug 'RRethy/vim-illuminate'
" 彩虹括号(
Plug 'junegunn/vim-after-object' " da= to delete what's after =
Plug 'skywind3000/asynctasks.vim'
Plug 'theniceboy/dart-vim-plugin'
Plug 'chrisbra/NrrwRgn'
Plug 'pechorin/any-jump.vim'

call plug#end()




" ===
" === coc
" ===
" fix the most annoying bug that coc has
"silent! au BufEnter,BufRead,BufNewFile * silent! unmap if
let g:coc_global_extensions = [
  \ 'coc-actions',
  \ 'coc-css',
  \ 'coc-diagnostic',
  \ 'coc-explorer',
  \ 'coc-flutter',
  \ 'coc-gitignore',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-lists',
  \ 'coc-prettier',
  \ 'coc-pyright',
  \ 'coc-python',
  \ 'coc-snippets',
  \ 'coc-sourcekit',
  \ 'coc-stylelint',
  \ 'coc-syntax',
  \ 'coc-tasks',
  \ 'coc-todolist',
  \ 'coc-translator',
  \ 'coc-tslint-plugin',
  \ 'coc-tsserver',
  \ 'coc-vimlsp',
  \ 'coc-vimlsp',
  \ 'coc-yaml',
  \ 'coc-yank']
"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
"nmap <silent> <TAB> <Plug>(coc-range-select)
"xmap <silent> <TAB> <Plug>(coc-range-select)
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]	=~ '\s'
endfunction
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <c-o> coc#refresh()
function! Show_documentation()
	call CocActionAsync('highlight')
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
nnoremap <LEADER>h :call Show_documentation()<CR>
" autocmd CursorHold * silent call CocActionAsync('highlight')


" Open up coc-commands
nnoremap <c-c> :CocCommand<CR>

" Text Objects
xmap kf <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap kf <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)
" Useful commands
nnoremap <silent> <space>y :<C-u>CocList -A --normal yank<cr>
" 跳转到函数定义的地方
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
" 函数的所有引用
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
nmap tt :CocCommand explorer<CR>
" coc-translator
nmap ts <Plug>(coc-translator-p)
" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@
" coctodolist
nnoremap <leader>tn :CocCommand todolist.create<CR>
nnoremap <leader>tl :CocList todolist<CR>
nnoremap <leader>tu :CocCommand todolist.download<CR>:CocCommand todolist.upload<CR>
" coc-tasks
noremap <silent> <leader>ts :CocList tasks<CR>
" coc-snippets
imap <C-l> <Plug>(coc-snippets-expand)
vmap <C-e> <Plug>(coc-snippets-select)
let g:coc_snippet_next = '<c-e>'
let g:coc_snippet_prev = '<c-n>'
imap <C-e> <Plug>(coc-snippets-expand-jump)
let g:snips_author = 'xm'

nmap <silent> <LEADER>n <Plug>(coc-diagnostic-prev)
nmap <silent> <LEADER>N <Plug>(coc-diagnostic-next)



" ===
" === Markdown
" ===
" let g:mkdp_auto_start = 0
" let g:mkdp_auto_close = 1
" let g:mkdp_refresh_slow = 0
" let g:mkdp_command_for_global = 0
" let g:mkdp_open_to_the_world = 0
" let g:mkdp_open_ip = ''
" let g:mkdp_browser = 'chromium'
" let g:mkdp_echo_preview_url = 0
" let g:mkdp_browserfunc = ''
" let g:mkdp_preview_options = {
  " \ 'mkit': {},
  " \ 'katex': {},
  " \ 'uml': {},
  " \ 'maid': {},
  " \ 'disable_sync_scroll': 0,
  " \ 'sync_scroll_type': 'middle',
  " \ 'hide_yaml_meta': 1
  " \ }
" let g:mkdp_markdown_css = ''
" let g:mkdp_highlight_css = ''
" let g:mkdp_port = ''
" let g:mkdp_page_title = ' 「${name}」 '

" ===
" === vim-table-mode
" ===
noremap <LEADER>tm :TableModeToggle<CR>
"let g:table_mode_disable_mappings = 1
let g:table_mode_cell_text_object_i_map = 'k<Bar>'

" ===
" === Vista.vim
" ===
noremap <LEADER>v :Vista coc<CR>
noremap <c-t> :silent! Vista finder coc<CR>
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'ctags'
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
" function! NearestMethodOrFunction() abort
" 	return get(b:, 'vista_nearest_method_or_function', '')
" endfunction
" set statusline+=%{NearestMethodOrFunction()}
" autocmd VimEnter * call vista#RunForNearestMethodOrFunction()


" ===
" === FZF
" ===
" set rtp+=/usr/local/opt/fzf
" set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
" set rtp+=/home/xm/.linuxbrew/opt/fzf
noremap <C-p> :Files<CR>
" noremap <C-f> :Rg<CR>
" noremap <C-h> :History<CR>
" "noremap <C-t> :BTags<CR>
" noremap <C-l> :Lines<CR>
" noremap <C-w> :Buffers<CR>
" noremap <leader>; :History:<CR>
" 
" let g:fzf_preview_window = 'right:60%'
" let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
" 
" function! s:list_buffers()
  " redir => list
  " silent ls
  " redir END
  " return split(list, "\n")
" endfunction
" 
" function! s:delete_buffers(lines)
  " execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
" endfunction
" 
" command! BD call fzf#run(fzf#wrap({
  " \ 'source': s:list_buffers(),
  " \ 'sink*': { lines -> s:delete_buffers(lines) },
  " \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
" \ }))
" 
" noremap <c-d> :BD<CR>

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }


" ===
" === vim-signiture
" ===
let g:SignatureMap = {
        \ 'Leader'             :  "m",
        \ 'PlaceNextMark'      :  "m,",
        \ 'ToggleMarkAtLine'   :  "m.",
        \ 'PurgeMarksAtLine'   :  "dm-",
        \ 'DeleteMark'         :  "dm",
        \ 'PurgeMarks'         :  "dm/",
        \ 'PurgeMarkers'       :  "dm?",
        \ 'GotoNextLineAlpha'  :  "m<LEADER>",
        \ 'GotoPrevLineAlpha'  :  "",
        \ 'GotoNextSpotAlpha'  :  "m<LEADER>",
        \ 'GotoPrevSpotAlpha'  :  "",
        \ 'GotoNextLineByPos'  :  "",
        \ 'GotoPrevLineByPos'  :  "",
        \ 'GotoNextSpotByPos'  :  "mn",
        \ 'GotoPrevSpotByPos'  :  "mp",
        \ 'GotoNextMarker'     :  "",
        \ 'GotoPrevMarker'     :  "",
        \ 'GotoNextMarkerAny'  :  "",
        \ 'GotoPrevMarkerAny'  :  "",
        \ 'ListLocalMarks'     :  "m/",
        \ 'ListLocalMarkers'   :  "m?"
        \ }


" ===
" === Undotree
" ===
noremap <LEADER>ut :UndotreeToggle<CR>
let g:undotree_DiffAutoOpen = 1
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
let g:undotree_WindowLayout = 2
let g:undotree_DiffpanelHeight = 8
let g:undotree_SplitWidth = 24
" function g:Undotree_CustomMap()
	" nmap <buffer> u <plug>UndotreeNextState
	" nmap <buffer> e <plug>UndotreePreviousState
	" nmap <buffer> U 5<plug>UndotreeNextState
	" nmap <buffer> E 5<plug>UndotreePreviousState
" endfunc


" ===
" === vim-visual-multi
" ===
"let g:VM_theme             = 'iceblue'
"let g:VM_default_mappings = 0
let g:VM_leader                     = {'default': ',', 'visual': ',', 'buffer': ','}
let g:VM_maps                       = {}
let g:VM_custom_motions             = {'j': 'h', 'l': 'l', 'i': 'k', 'k': 'j', 'J': '0', 'L': '$', 'e': 'e'}
let g:VM_maps['i']                  = 'h'
let g:VM_maps['I']                  = 'H'
let g:VM_maps['Find Under']         = '<C-d>'
let g:VM_maps['Find Subword Under'] = '<C-d>'
let g:VM_maps['Find Next']          = ''
let g:VM_maps['Find Prev']          = ''
let g:VM_maps['Remove Region']      = 'q'
let g:VM_maps['Skip Region']        = '<c-n>'
let g:VM_maps["Undo"]               = 'u'
let g:VM_maps["Redo"]               = '<C-r>'


" Open Startify
noremap <LEADER>st :Startify<CR>

" ===
" === Far.vim
" ===
noremap <LEADER>f :F  %<left><left>
"noremap <LEADER>f :F  **/*<left><left><left><left><left>
" let g:far#mapping = {
" 		\ "replace_undo" : ["l"],
" 		\ }


" ===
" === Bullets.vim
" ===
" let g:bullets_set_mappings = 0
let g:bullets_enabled_file_types = [
			\ 'markdown',
			\ 'text',
			\ 'gitcommit',
			\ 'scratch'
			\]

" ===
" === vim-go
" ===
let g:go_echo_go_info = 0
let g:go_doc_popup_window = 1
let g:go_def_mapping_enabled = 0
let g:go_template_autocreate = 0
let g:go_textobj_enabled = 0
let g:go_auto_type_info = 1
let g:go_def_mapping_enabled = 0
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_functions = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_structs = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_assignments = 0
let g:go_highlight_variable_declarations = 0
let g:go_doc_keywordprg_enabled = 0


" ===
" === vim-after-object
" ===
autocmd VimEnter * call after_object#enable('=', ':', '-', '#', ' ')


" ===
" === suda.vim
" ===
cnoreabbrev sudowrite w suda://%
cnoreabbrev sw w suda://%


" ===
" === vim-illuminate
" ===
let g:Illuminate_delay = 750
hi illuminatedWord cterm=undercurl gui=undercurl


" ===
" === AsyncTasks
" ===
let g:asyncrun_open = 6


" ===
" === dart-vim-plugin
" ===
let g:dart_style_guide = 2
let g:dart_format_on_save = 1
let g:dartfmt_options = ["-l 100"]


" ===
" === NrrwRgn
" ===
let g:nrrw_rgn_nomap_nr = 1
let g:nrrw_rgn_nomap_Nr = 1
noremap <c-y> :NR<CR>


" ===
" === any-jump
" ===
let g:any_jump_disable_default_keybindings=1
let g:any_jump_window_width_ratio  = 0.8
let g:any_jump_window_height_ratio = 0.9
nnoremap <LEADER>; :AnyJump<CR>
xnoremap <LEADER>; :AnyJumpVisual<CR>
nnoremap <LEADER>ab :AnyJumpBack<CR>
xnoremap <LEADER>al; :AnyJumpLastResults<CR>

" Open the _machine_specific.vim file if it has just been created
" if has_machine_specific_file == 0
" 	exec "e ~/.config/nvim/_machine_specific.vim"
" endif

" ===
" === vim-airline
" ===
let g:airline_theme='dracula'
let g:airline#extensions#tabline#buffer_nr_show=1


"" ===
"" === rnvimr
"" ===
"let g:rnvimr_ex_enable = 1
"let g:rnvimr_pick_enable = 1
"let g:rnvimr_draw_border = 0
"" let g:rnvimr_bw_enable = 1
"highlight link RnvimrNormal CursorLine
"nnoremap <silent> R :RnvimrSync<CR>:RnvimrToggle<CR><C-\><C-n>:RnvimrResize 0<CR>
"let g:rnvimr_action = {
            "\ '<C-t>': 'NvimEdit tabedit',
            "\ '<C-x>': 'NvimEdit split',
            "\ '<C-v>': 'NvimEdit vsplit',
            "\ 'gw': 'JumpNvimCwd',
            "\ 'yw': 'EmitRangerCwd'
            "\ }
"let g:rnvimr_layout = { 'relative': 'editor',
            "\ 'width': &columns,
            "\ 'height': &lines,
            "\ 'col': 0,
            "\ 'row': 0,
            "\ 'style': 'minimal' }
"let g:rnvimr_presets = [{'width': 1.0, 'height': 1.0}]

" ===
" === fcitx5-vim
" ===
let g:input_toggle = 1
function! Fcitx2en()
   let s:input_status = system("fcitx5-remote")
   if s:input_status == 2
      let g:input_toggle = 1
      let l:a = system("fcitx5-remote -c")
   endif
endfunction
function! Fcitx2zh()
   let s:input_status = system("fcitx5-remote")
   if s:input_status != 2 && g:input_toggle == 1
      let l:a = system("fcitx5-remote -o")
      let g:input_toggle = 0
   endif
endfunction

set timeoutlen=150
autocmd InsertLeave * call Fcitx2en()
"autocmd InsertEnter * call Fcitx2zh()
