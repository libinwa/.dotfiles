" Specify a directory for plugins
call plug#begin(PackHome())
"
" List the plugins with Plug commands
Plug 'tpope/vim-fugitive'
Plug 'editorconfig/editorconfig-vim'
Plug 'yegappan/lsp'
"Plug 'junegunn/fzf'
"Plug 'junegunn/fzf.vim'
"Plug 'ludovicchabant/vim-gutentags'
"Plug 'skywind3000/gutentags_plus'
"Plug 'puremourning/vimspector'
"Plug 'diepm/vim-rest-console'
"Plug 'Freed-Wu/cppinsights.vim'
"Plug 'girishji/devdocs.vim'
"Plug 'madox2/vim-ai'
call plug#end()
" INITIALIZATION OF PLUGINs

"
" Settings Plug 'yegappan/lsp'
"
"{
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
"}

"
" Settings
" Plug 'junegunn/fzf'
" Plug 'junegunn/fzf.vim'
"
"{
if isdirectory(PackHome().'/fzf')
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
  command! -nargs=? -bang Rg  CD | call fzf#vim#grep('rg      --column --line-number --no-heading --color=always --smart-case -- '.fzf#shellescape(<q-args>), fzf#vim#with_preview(), <bang>0)
  command! -nargs=? -bang Rga CD | call fzf#vim#grep('rg -uuu --column --line-number --no-heading --color=always --smart-case -- '.fzf#shellescape(<q-args>), fzf#vim#with_preview(), <bang>0)
  command! -bang Fb FzBuffers
  nmap <leader><tab> <plug>(fzf-maps-n)
  xmap <leader><tab> <plug>(fzf-maps-x)
  omap <leader><tab> <plug>(fzf-maps-o)
endif
"}

"
" Settings
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'skywind3000/gutentags_plus'
"
"{
if isdirectory(PackHome().'/vim-gutentags')
  let g:gutentags_project_root = g:this_project.markers
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
endif
"}

"
"Tips:
" Open file location
" !start .
" Open file with default program
" !start %
" !start /B %
" How can I insert invisible keys into the MACRO key sequence? Press CTRL-V and then press invisible keys to input.
" CTRL-@ ==>^@==><LF>(new line?)==>(LF?CR?)==>'\n


"
" local defs
"
if filereadable(ProjectDir().'/.vimrc.local')
  exec 'source '.ProjectDir().'/.vimrc.local'
endif

"
" local envs
"
let $PATH = MyVimrcDir()."/tools.libs.scripts/scripts".";".$PATH    " Got env of my scripts
if isdirectory("C:/Program Files/Git/usr/bin") | let $PATH = "C:/Program Files/Git/usr/bin".";".$PATH | endif       " for various tool at git home.
if isdirectory("C:\\Program Files (x86)\\Sun xVM VirtualBox") | let $PATH = "C:\\Program Files (x86)\\Sun xVM VirtualBox".";".$PATH | endif
if exists('&pythonthreehome') | let &pythonthreehome=expand("$HOME/.conda/envs/py38") | let $PATH = &pythonthreehome.";".&pythonthreehome."/Scripts;".$PATH | endif
" http_proxy and https_proxy pointing to px (http://127.0.0.1:3128)
"let $HTTP_PROXY="http://127.0.0.1:3128"
"let $HTTPS_PROXY="http://127.0.0.1:3128"

"
" colo, transparent
"
colo industry
"if !has('gui_running')
"  hi Normal  guibg=NONE ctermbg=NONE
"  hi LineNr  guibg=NONE ctermbg=NONE
"  hi NonText guibg=NONE ctermbg=NONE
"  hi EndOfBuffer guibg=NONE ctermbg=NONE
"endif
