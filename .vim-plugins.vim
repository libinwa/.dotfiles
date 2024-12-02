" Specify a directory for plugins
call plug#begin(PackHome())
"
" List the plugins with Plug commands
"
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'yegappan/lsp'
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'
Plug 'diepm/vim-rest-console'
Plug 'Freed-Wu/cppinsights.vim'
Plug 'puremourning/vimspector'
call plug#end()
" INITIALIZATION OF PLUGINs

""""""""""""""""""""""""""""""""""""""
" Settings
" Plug 'junegunn/fzf'
" Plug 'junegunn/fzf.vim'
""""""""""""""""""""""""""""""""""""""
let g:fzf_command_prefix = 'Fz'
command! -bang FzDiffs call fzf#vim#files(ProjectDir(), {'sink': 'diffsplit'}, <bang>0)
if has('popupwin')
    let g:fzf_layout={'window':{'width':0.9, 'height':0.6, 'border':'rounded', 'highlight':'Question'}}
endif
if executable('fzf') && !exists('g:loaded_fzf')
    let fzf_script_needed = expand($HOME).'/.fzf/plugin/fzf.vim'
    if filereadable(fzf_script_needed)
        exec 'source '.fzf_script_needed
    endif
endif
command! -bang Fd  call fzf#vim#files(ProjectDir(), fzf#vim#with_preview({'source':'rg --files                      --follow'}), <bang>0)
command! -bang Fda call fzf#vim#files(ProjectDir(), fzf#vim#with_preview({'source':'rg --files --no-ignore --hidden --follow'}), <bang>0)
command! -nargs=? -bang Rg  exec 'lcd' ProjectDir() | call fzf#vim#grep('rg      --column --line-number --no-heading --color=always --smart-case -- '.fzf#shellescape(<q-args>), fzf#vim#with_preview(), <bang>0)
command! -nargs=? -bang Rga exec 'lcd' ProjectDir() | call fzf#vim#grep('rg -uuu --column --line-number --no-heading --color=always --smart-case -- '.fzf#shellescape(<q-args>), fzf#vim#with_preview(), <bang>0)
command! -bang Fzb FzBuffers
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

""""""""""""""""""""""""""""""""""""""
" Settings Plug 'yegappan/lsp'
""""""""""""""""""""""""""""""""""""""
let lspServers = []
if executable('clangd')
    let lspServers += [#{
                \     name: 'clang',
                \     filetype: ['c', 'cpp'],
                \     path: 'clangd',
                \     args: ['--background-index', '--log=verbose']
                \    }]
endif
if executable('rust-analyzer')
    let lspServers += [#{
                \    name: 'rustlang',
                \    filetype: ['rust'],
                \    path: 'rust-analyzer',
                \    args: [],
                \    syncInit: v:true
                \   }]
endif
if executable('lua-language-server')
    let lspServers += [#{
                \    name: 'lua',
                \    filetype: ['lua'],
                \    path: 'lua-language-server',
                \    args: []
                \   }]
endif
if executable('pylsp')
    let lspServers += [#{name: 'pylsp',
                 \   filetype: 'python',
                 \   path: 'pylsp',
                 \   args: []
                 \ }]
endif
"if executable('neocmakelsp-x86_64-pc-windows-msvc')
"    let lspServers += [#{name: 'neocmakelsp',
"                \ filetype: 'cmake',
"                \ path: 'neocmakelsp-x86_64-pc-windows-msvc',
"                \ args: ['--stdio', '-v']
"                \ }]
"endif
"if executable('cmake-language-server')
"    let lspServers += [#{name: 'cmakelsp',
"                \ filetype: 'cmake',
"                \ path: 'cmake-language-server',
"                \ initializationOptions: #{
"                \     buildDirectory:ProjectDir()
"                \   }
"                \ }]
"endif

let lspOpts = #{autoHighlightDiags: v:true}
function! OnLspAttached()
    setlocal formatexpr=lsp#lsp#FormatExpr()
    " To jump to the symbol definition using the vim tag-commands Ctrl-]
    if exists('+tagfunc') | setlocal tagfunc=lsp#lsp#TagFunc | endif
    "Switch between source and header files.
    nmap <buffer> ,O :LspSwitchSourceHeader<CR>
    nmap <buffer> gd :LspGotoDefinition<CR>
    nmap <buffer> gs :LspDocumentSymbol<CR>
    nmap <buffer> gS :LspSymbolSearch<CR>
    nmap <buffer> gr :LspPeekReferences<CR>
    nmap <buffer> gi :LspGotoImpl<CR>
    "nmap <buffer> gt :LspGotoTypeDef<CR>
    nmap <buffer> gt :LspGotoDeclaration<CR>
    nmap <buffer> <leader>rn :LspRename<CR>
    nmap <buffer> [g :LspDiagPrev<CR>
    nmap <buffer> ]g :LspDiagNext<CR>
    nmap <buffer> K  :LspHover<CR>
endfunction

augroup lsp_install
    au!
    autocmd VimEnter * if exists('*LspAddServer') | call LspAddServer(lspServers) | endif
    autocmd VimEnter * if exists('*LspOptionsSet') | call LspOptionsSet(lspOpts) | endif
    autocmd User LspAttached call OnLspAttached()
augroup END


""""""""""""""""""""""""""""""""""""""
" Settings
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'skywind3000/gutentags_plus'
""""""""""""""""""""""""""""""""""""""
let g:gutentags_project_root = g:theProject.markers
let g:gutentags_add_default_project_roots = 0
let g:gutentags_modules = []
if executable('ctags')
    let g:gutentags_modules += ['ctags']
endif
if executable('gtags') && executable('gtags-cscope')
    let g:gutentags_modules += ['gtags_cscope']
endif
let g:gutentags_ctags_tagfile = '.cache/.tags'
let g:gutentags_gtags_dbpath = '.cache/tags'
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
let g:gutentags_auto_add_gtags_cscope = 0
let g:gutentags_define_advanced_commands = 1
let g:gutentags_plus_switch = 1

" env
let $PATH = MyVimrcDir()."/tools.libs.scripts/scripts".";".$PATH    " Got env of my scripts
if isdirectory("C:/Program Files/Git/usr/bin") | let $PATH = "C:/Program Files/Git/usr/bin".";".$PATH | endif       " for various tool at git home.
if isdirectory("C:\\Program Files (x86)\\Sun xVM VirtualBox") | let $PATH = "C:\\Program Files (x86)\\Sun xVM VirtualBox".";".$PATH | endif
if exists('&pythonthreehome') | let &pythonthreehome=expand("$HOME/.conda/envs/py38") | let $PATH .= ";".&pythonthreehome.";".&pythonthreehome."/Scripts" | endif


colo industry
" transparent
"hi Normal  guibg=NONE ctermbg=NONE
"hi NonText guibg=NONE ctermbg=NONE
"hi LineNr  guibg=NONE ctermbg=NONE


"Tips:
"-----
"Press CTRL-V and then invisible character key to input specific key at keyboard.
"CTRL-@ ==>^@==><LF>(new line?)==>(LF?CR?)==>'\n

" usefull snippets:
" ------- macros/registers -------
"let @w='0oif (CMAKE_EXPORT_COMPILE_COMMANDS) add_custom_target( copy-compile-commands ALL ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BINARY_DIR}/compile_commands.json ${CMAKE_CURRENT_LIST_DIR} COMMENT "Copy ${CMAKE_BINARY_DIR}/compile_commands.json to ${CMAKE_CURRENT_LIST_DIR} ") endif() '
"Git: How to pick specific commits to this branch.
"  git cherry-pick <commitId>  --no-commit #Pick the target commit to this branch
"  git cherry-pick <commitId>..<commintId> --no-commit   #Pick commits(A,B] to this branch
"  git cherry-pick <commitId>^..<commitId> --no-commit   #Pick commits[A,B] to this branch
"  git cherry-pick <branch> --no-commit     #Pick the HEAD commit to this branch.
"
""Local making, /path/to/scripts/make.bat has added.
"Quick make . debug
"Start make . release
"
""How about remote? (Sync to remote==>Remote make&test)
""After adding the remote host into the $HOME/.ssh/config, try `Sync ./*`
""SSH can do remote commands like: ssh remotehost "-----call shell script to do the make-----"
""Try remote make with it: Start ssh libin@NanoPi "cd /var/tmp/cmakelua4/private/make; export LINUX_FLAVOR=./linux_flavor.sh;./build.sh `$LINUX_FLAVOR`-gcc-x64 debug"
""
""For the Static-Check, append /path/to/tool_cppcheck.bat script
"let $PATH = "path/to/tool_cppcheck".";".$PATH
"exec 'cd ' ProjectDir() | Quick run_cppcheck.bat

" Make sentences...
"  她已经知道这件事了，我口误（说溜了嘴, slip of the tongue）说了。
"  She has known this thing, I slipped of the tongue.
"
