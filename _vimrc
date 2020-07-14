"/*********************************************************************
"
"- File name: _vimrc
"- Author: libin    Version: -       Date: 2018-03-05 11:56:09
"- Description:   My personal vimrc, support plugins configured in a
"  vim-plugins.json file.
"  1. File `PackHome().'/vim-plugins.json'` is used to manage plugin(s).
"     For the json `key-value` format, please refer to the default
"     `vim-plugins.json` file.
"  2. You can easily execute `:RcUpdate` in Ex mode to update
"     `_vimrc` file.
"
"- Others:         // 其它内容的说明
"  Easily copy this file to your `$HOME` to initialize vim. If the default
"  `vim-plugins.json` file not exists, it will be created by this _vimrc
"  script.
"
"- Function List:
"  `:PackUpdate` to update/download plugin(s) configured in the json file.
"  `:Packend` to reload all plugin(s) `on_finish` script in the json file.
"  `:Packend start/opt` to reload start/opt plugin(s) `on_finish` script.
"  `:Packend plugin1name plugin2name` to load `on_finish` script configured
"  in the json file for plugin(s).
"
"- History:
"    1. Date:2018-12-30 22:08:45
"       Author: libin
"       Modification: Add RcUpdate, object oriented encapsulation for
"       vim job APIs. Encapsulation jobwindow single instance for job
"    2. Date:2019-09-22 21:56:21
"       Author: libin
"       Modification: Add Selection function, used to get current selection
"       string. Add SignIn target server function. Add Redir2Wnd function
"       output the result of the Ex command into a split scratch buffer.
"*********************************************************************/


" Environment {

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/sh
        endif
    " }

    " Linux Compatible {
        if LINUX()
            if has('gui_running')
                " Source a global configuration file if available
                if filereadable("/etc/vim/gvimrc.local")
                    source /etc/vim/gvimrc.local
                endif
            else
                " This line should not be removed as it ensures that various options are
                " properly set to work with the Vim-related packages available in Debian.
                runtime! debian.vim

                " Source a global configuration file if available
                if filereadable("/etc/vim/vimrc.local")
                    source /etc/vim/vimrc.local
                endif
            endif
        endif
    " }

    " Arrow Key Fix {
        if &term[:4] ==? "xterm" || &term[:5] ==? 'screen' || &term[:3] ==? 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif
    " }
" }


" General {

    filetype on                     " Automatically detect file types
    filetype plugin on
    filetype plugin indent on

    set encoding=utf-8              " Sets the character encoding used inside Vim.
    scriptencoding utf-8            " If you set the 'encoding' option :scriptencoding must be placed after that.
    set fileencoding=utf-8          " Sets the character encoding for the file of this buffer.
    " This :fileencodings is a list of character encodings considered when starting to edit an existing file.
    " When a file is read, Vim tries to use the first mentioned character encoding.
    set fileencodings=ucs-bom,utf-8,gbk,gb2312,gb18030,big5,cp936,latin1

    syntax enable                   " Syntax highlighting

    set shortmess+=filmnrxoOtT      " Abbrev. of messages (avoids 'hit enter')
    "set shortmess=atI               " 去掉欢迎界面
    set mouse=a                     " Automatically enable mouse usage
    set mousehide                   " Hide the mouse cursor while typing
    set backspace=indent,eol,start  " Backspace for dummies
    "set backspace=2                 " Same as `set backspace=indent,eol,start`
    set number                      " Line numbers on
    set relativenumber              " Line relative numbers on
    set nowrap                      " Do not wrap long lines
    set virtualedit=onemore         " Allow for cursor beyond last character
    set autoindent                  " Indent at the same level of the previous line
    set smartindent                 " Enable smart indent
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set smarttab                    " 指定按一次backspace就删除shiftwidth宽度
    set softtabstop=4               " Let backspace delete indent
    set tabpagemax=15               " Only show 15 tabs
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set showmatch                   " Show matching brackets/parenthesis
    "set matchpairs+=<:>             " Match, to be used with %
    set incsearch                   " Find as you type search
    "set noincsearch                 " 在输入要搜索的文字时，取消实时匹配
    set hlsearch                    " Highlight search terms
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set hidden                      " Allow buffer switching without saving
    "set autowrite                   " Automatically write a file when leaving a modified buffer
    set autoread                    " 当文件在外部被修改，自动更新该文件
    set spell                       " Spell checking on
    set iskeyword-=.                " '.' is an end of word designator
    set iskeyword-=#                " '#' is an end of word designator
    set iskeyword-=-                " '-' is an end of word designator
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    "set vb t_vb=                    " 关闭提示音
    set history=1000                " Store a ton of history (default is 20)
    set viewoptions=folds,options,cursor,unix,slash    " Better Unix / Windows compatibility

    set nofoldenable                " 禁用折叠
    "set foldenable                  " 启用折叠
    set foldmethod=indent           " indent 折叠方式
    "set foldmethod=marker           " marker 折叠方式
    " 常规模式下用空格键来开关光标行所在折叠（注：zR 展开所有折叠，zM 关闭所有折叠）
    nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    " Setting up the list characters
    if !WINDOWS() || has('gui_running')
        " 非可见字符不显示, `set list`可按预定字符(listchars指定)替代显示非可见字符
        set list
        " 设置非可见字符的显示时的可见字符替代方案
        set listchars=tab:›\ ,trail:•,extends:>,precedes:<,nbsp:.
        if &encoding !=? 'utf-8'
            let warning_msg = printf("The encoding option is not utf-8 (it's %s), ".
                                    \"make sure characters of listchars (%s) valid please.",
                                    \&encoding, &listchars)
            echohl WarningMsg | echomsg warning_msg | echohl NONE
        endif
    else
        set nolist
    endif

    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened; To prevent this behavior, open the following
    " comment line:
    "let g:no_autochdir = 1
    if !exists('g:no_autochdir')
        augroup chDir
            autocmd!
            " Always switch to the current file directory
            autocmd BufEnter * if &buftype !=? 'terminal' && bufname("")
                        \!~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
        augroup END
    endif

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    " To disable this, uncommenting the next line.
    "let g:no_restore_cursor = 1
    if !exists('g:no_restore_cursor')
        function! ResCur()
            if line("'\"") <= line("$")
                silent! normal! g`"
                return 1
            endif
        endfunction

        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END
    endif

    " Set tags option {
        " A tag is an identifier that appears in a "tags" file.  It is a sort of label
        " that can be jumped to.  For example: In C programs each function name can be
        " used as a tag.  The "tags" file has to be generated by a program like ctags,
        " before the tag commands can be used.
        "
        " With the ":tag" command the cursor will be positioned on the tag.  With the
        " CTRL-] command, the keyword on which the cursor is standing is used as the
        " tag.  If the cursor is not on a keyword, the first keyword to the right of the
        " cursor is used.
        "
        " For more infomation, please ":h tags"
        "
        " 设置索引文件生成工具生成索引文件时应用的索引文件文件名
        " 索引文件缺省文件名是 "tags"

        " 以小数点开头更便于识别, 以下设置索引文件名为".tags",
        " `./.tags;`整体表示若当前编辑的文件所在目录中不存在.tags， 则在其父目录中查找.tags直至根目录。
        " 分号 ; 不可省略!!!
        set tags=./.tags;

        " `.tags` 整体表示在vim的当前工作目录,即函数getcwd()返回的路径下查找.tags
        set tags+=.tags
    " }

    " Use cscope if available {
        if has("cscope")
            set csprg=cscope
            set csto=0
            set cst
            set nocsverb
            " add any database in current directory
            if filereadable("cscope.out")
                cs add cscope.out
            " else add database pointed to by environment
            elseif $CSCOPE_DB != ""
                cs add $CSCOPE_DB
            endif
            set csverb
        endif
    "}

    " Use gtags if available {
        " A source code tagging system that works the same way
        " across diverse environments
        if executable('gtags')
            " Enviroment variable $GTAGSCONF for `gtags --gtagsconf </path/to/gtags/gtags.conf>`,
            " Enviroment variable $GTAGSLABEL for `gtags --gtagslabel <LABEL>`
            "let  $GTAGSCONF = /path/to/gtags/gtags.conf
            let $GTAGSLABEL = 'native-pygments'
            if has("cscope") && executable('gtags-cscope')
                set csprg=gtags-cscope
            endif
        endif
    " }

    " Setting up the directories {
        " To enable backup, uncommenting the next line.
        "let g:backup_enable = 1
        if exists('g:backup_enable')
            set backup                  " Backups are nice ...
        else
            set nobackup                " 设置无备份文件
            set writebackup             " 保存文件前建立备份，保存成功后删除该备份
            set noswapfile              " 设置无临时文件
        endif

        " To disable persistent_undo, uncommenting the next line.
        "let g:no_persistent_undo = 1
        if !exists('g:no_persistent_undo') && has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " To disable views, uncommenting the next line.
        "let g:no_views = 1
        if !exists('g:no_views')
            " Add exclusions to mkview and loadview
            " eg: *.*, svn-commit.tmp
            let g:skipview_files = [
                \ '\[example pattern\]'
                \ ]
        endif
    " }

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    augroup gitcommitEditMSG
        autocmd!
        autocmd FileType gitcommit autocmd! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
    augroup END
" }


" Key (re)Mappings {
    " The user-defined command and abbreviation placed in this section too
    " The default Leader is '\', you can set it to any other character override this behavior
    let g:mapleader = '\'
    " 注：上面配置"<Leader>"为"\"键（引号里的反斜杠），如<Leader>t
    " 指在常规模式下按"\"键加"t"键，这里不是同时按，而是先按"\"键后按"t"键，间隔在一
    " 秒内，而<Leader>cs是先按"\"键再按"c"又再按"s"键

    " 这个mapping会为你的左手减轻很多负担
    inoremap jk <ESC>

    " Goto file under cursor, opens file in a new vertical
    nnoremap gf :vertical wincmd f<CR>

    nnoremap lt :Lexplore<CR>

    " Backspace to cancel match-highlight provisionally
    nnoremap <BS> :noh<CR>

    " 在新的分屏中打开我的 ~/.vimrc 文件
    nnoremap <Leader>ve :vsplit $MYVIMRC<CR>

    " 重读我的 ~/.vimrc 文件
    nnoremap <Leader>sv :source $MYVIMRC<CR>

    " 常规模式下输入<Leader>cS清除行尾空格
    nnoremap <Leader>cS :%s/\s\+$//g<CR>:noh<CR>

    " 常规模式下输入<Leader>cM清除行尾^M符号
    nnoremap <Leader>cM :%s/\r$//g<CR>:noh<CR>

" }


" Vim UI {
    " Assume a dark background, allow to toggle background
    " via the ToggleBG function
    set background=dark
    " Allow to trigger background
    function! ToggleBG()
        let s:tbg = &background
        " Inversion
        if s:tbg ==? "dark"
            set background=light
        else
            set background=dark
        endif
    endfunction
    nnoremap <Leader>bg :call ToggleBG()<CR>

    set winminheight=0              " Windows can be 0 line high
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    set fillchars=vert:\ ,fold:-    " Set characters to fill the statuslines and vertical separators.
                                    " The fillchars option default string is "vert:|,fold:-"
    set cursorline                  " Highlight current line
    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set showmode                    " Display the current mode

    set cmdheight=2                 " Set command line height as 2，default 1
    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2                         " Switch status line on

        " Check file status description variable, return the string value
        function! FstatStr()
            let filestat = ''
            let fbufnr = bufnr("")
            if exists('g:filestat') && has_key(g:filestat, fbufnr)
                let filestat = ':'.g:filestat[fbufnr].' '
            endif
            return filestat
        endfunction

        " Get fileencoding string value
        function! FencStr()
            let fencStr = empty(&fenc) ? &enc : &fenc
            let bombStr = (exists('+bomb') && &bomb) ? ' with BOM' : ''
            return fencStr.bombStr
        endfunction

        " Broken down into easily includeable segments
        set statusline=%<%f\                            " Filename
        set statusline+=%{FstatStr()}                   " Append file status string
        set statusline+=%w%h%m%r                        " Options
        set statusline+=\ [%{FencStr()}][%{&ff}/%Y]     " Fileencoding and Filetype
        "set statusline+=\ [%{getcwd()}]                " Current dir
        set statusline+=%=%-10.(%p%%\ %l:%c%V%)\         " Right aligned file nav info
    endif
" }


" GUI Settings {
    if has('gui_running')
        set lines=40                " 指定窗口大小，lines为高度，columns为宽度
        set columns=120
        " autocmd GUIEnter * simalt ~x   " 窗口启动时自动最大化
        winpos 100 10               " 指定窗口出现的位置，坐标原点在屏幕左上角

        " 显示/隐藏菜单栏、工具栏、滚动条，可用 <C-F11> 切换
        set guioptions-=m           " Remove the menubar
        set guioptions-=T           " Remove the toolbar
        set guioptions-=r
        set guioptions-=L
        nnoremap <silent> <C-F11> :if &guioptions =~# 'm' <Bar>
            \set guioptions-=m <Bar>
            \set guioptions-=T <Bar>
            \set guioptions-=r <Bar>
            \set guioptions-=L <Bar>
        \else <Bar>
            \set guioptions+=m <Bar>
            \set guioptions+=T <Bar>
            \set guioptions+=r <Bar>
            \set guioptions+=L <Bar>
        \endif<CR>

        if LINUX()
            set guifont=Inconsolata\ 15,Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
        elseif OSX()
            set guifont=Inconsolata:h15,Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
        elseif WINDOWS()
            set guifont=Inconsolata:h15,Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
        endif
    else
        " For compatible, according to current terminal environment,
        " set t_Co option to 256 colors or keep default
        if &term ==? 'xterm' || &term ==? 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
    endif
" }


" Formatting {
    " 启用每行超过某一字符总数后给予字符变化提示（字体变蓝加下划线等），不启用就注释掉
    let f = 2.0
    let g:pattern = printf('\%%>%dv.\+', float2nr(80 * f))
    augroup lineWidth
        autocmd!
        autocmd BufWinEnter * let w:m2=matchadd('Underlined', g:pattern, -1)
    augroup END
    " Remove trailing whitespaces and ^M chars
    " To disable the stripping of whitespace, uncommenting the next line.
    " let g:keep_trailing_whitespace = 1
    function! CheckTrailingWhitespace()
        if !exists('g:keep_trailing_whitespace')
            call StripTrailingWhitespace()
        endif
    endfunction
    augroup checkTrailingWhitespace
        autocmd!
        autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> call CheckTrailingWhitespace()
    augroup END

    if !exists('autocmdnogroup_loaded')
        let autocmdnogroup_loaded = 1
        autocmd BufNewFile,BufRead *.coffee set filetype=coffee
        autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
        "autocmd FileType go autocmd BufWritePre <buffer> Fmt
        autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
        " preceding line best in a plugin but here for now.

        " Workaround vim-commentary for Haskell
        autocmd FileType haskell setlocal commentstring=--\ %s
        " Workaround broken colour highlighting in Haskell
        autocmd FileType haskell,rust setlocal nospell
    endif
" }


" Job {
    " Description:  Object oriented encapsulation for vim job APIs
    "   job is an object as following:
    " +--------------------------------------------------------------------------------------------------------------------+
    " |    job                                                                                                             |
    " |--------------------------------------------------------------------------------------------------------------------|
    " | cmd       `` 构造job时的入参a:cmd参数提供, 若a:cmd是[]类型,构造时内部转换入参a:cmd为字符串                         |
    " |              e.g. let l:cmd = type(a:cmd) ==? type([]) ? join(a:cmd, ' ') : a:cmd                                  |
    " | name      ``\        " default job name is 'unnamed'                                                               |
    " | cwd        ``\       " default job cwd is getcwd() api returned value                                              |
    " | mode        ``\      " default 'raw', refer to vim job APIs                                                        |
    " |                + 构造job时构造函数使用{}类型的入参a:opts提供的属性值初始化这些属性,否则构造时这些属性使用其默认值  |
    " | on_stderr   ../                                                                                                    |
    " | on_stdout  ../                                                                                                     |
    " | on_exit   ../        " on_stderr/on_stdout/on_exit are empty in default                                            |
    " |                                                                                                                    |
    " | jobid                " key of job in the jobs dictionary                                                           |
    " |                                                                                                                    |
    " | vimjob_object    " vim job object returned by job_start()                                                          |
    " | vimjob_channel   " vim job channel returned by job_getchannel()                                                    |
    " |--------------------------------------------------------------------------------------------------------------------|
    " | clear()                                                                                                            |
    " | log()                                                                                                              |
    " | start()                                                                                                            |
    " | stop(...)                                                                                                          |
    " | status()                                                                                                           |
    " | channel()                                                                                                          |
    " | info()                                                                                                             |
    " | send(data)                                                                                                         |
    " | wait(timeout)                                                                                                      |
    " |--------------------------------------------------------------------------------------------------------------------|
    " | Create(cmd, opts)                                                                                                  |
    " | Info()                                                                                                             |
    " | Wait(timeout)                                                                                                      |
    " |--------------------------------------------------------------------------------------------------------------------|
    " | " static properties                                                                                                |
    " | jobidseq = []                                                                                                      |
    " | kInvalidJobid = -1                                                                                                 |
    " | jobs = {}    "  {<jobid>:<job>, ...} dictionary                                                                    |
    " +--------------------------------------------------------------------------------------------------------------------+

    let s:save_cpo = &cpo
    set cpo&vim

    " jobid is key of job in the jobs dictionary
    " jobid start at invalid value(-1) jobid >= 0 is valid
    let g:Job = {
            \ 'jobidseq' : [-1],
            \ 'kInvalidJobid' : -1,
            \ 'jobs' : {}
            \ }

    function! g:Job.Create(cmd, opts)
        " Properties default value set
        let defaults = {
                     \ 'name'      : 'unnamed',
                     \ 'cwd'       : getcwd(),
                     \ 'mode'      : 'raw',
                     \ 'on_stderr' : '',
                     \ 'on_stdout' : '',
                     \ 'on_exit'   : ''
                     \ }
        let instance = extend(copy(self), extend(copy(a:opts), defaults, 'keep'))
        let instance.cmd = type(a:cmd) ==? type([]) ? join(a:cmd, ' ') : a:cmd
        if has_key(a:opts, 'name')
            let instance.name = a:opts.name
        endif
        if has_key(a:opts, 'cwd')
            let instance.cwd = a:opts.cwd
        endif
        if has_key(a:opts, 'mode')
            let instance.mode = a:opts.mode
        endif
        if has_key(a:opts, 'on_stderr')
            let instance.on_stderr = a:opts.on_stderr
        endif
        if has_key(a:opts, 'on_stdout')
            let instance.on_stdout = a:opts.on_stdout
        endif
        if has_key(a:opts, 'on_exit')
            let instance.on_exit = a:opts.on_exit
        endif

        call add(instance.jobidseq, get(instance.jobidseq, -1, instance.kInvalidJobid) + 1)
        let instance.jobid = get(instance.jobidseq, -1, instance.kInvalidJobid)
        if instance.jobid !=? instance.kInvalidJobid
            let instance.jobs[instance.jobid] = instance
        endif

        " vim job object returned by job_start()
        let vimjob_object = ''
        " log (record) job event/message
        let job_event_messages = []
        " vim job channel returned by job_getchannel()
        let vimjob_channel = ''

        function! instance.clear() closure
            let vimjob_object = ''
            let vimjob_channel = ''
            let job_event_messages = []
            if has_key(instance.jobs, instance.jobid)
                call remove(instance.jobs, instance.jobid)
            endif
        endfunction

        function! instance.log() closure
            return job_event_messages
        endfunction

        function! instance.log_event_message(messages) closure abort
            if type(a:messages) ==? type([])
                for l:msg in a:messages
                    " trim message string
                    let l:msg = substitute(l:msg, '^\s*\(.\{-}\)\s*$', '\1', '')
                    if !empty(l:msg)
                        call add(job_event_messages, l:msg)
                    endif
                endfor
            endif
            if type(a:messages) ==? type('')
                " trim message string
                let l:msg = substitute(a:messages, '^\s*\(.\{-}\)\s*$', '\1', '')
                if !empty(l:msg)
                    call add(job_event_messages, l:msg)
                endif
            endif
        endfunction

        function! instance.start() closure
            let l:msg = printf("[%s] Start job %s...", CurrentTime(), self.name)
            call self.log_event_message(l:msg)
            if has('job') && has('channel') && has('lambda')
                let vimjob_object = job_start(printf('%s %s "%s"', &shell, &shellcmdflag, self.cmd), {
                    \ 'out_cb': function('s:out_cb', self),
                    \ 'err_cb': function('s:err_cb', self),
                    \ 'exit_cb': function('s:exit_cb', self),
                    \ 'mode': self.mode,
                    \ 'cwd': self.cwd
                \})
                if job_status(vimjob_object) ==? 'run'
                    let l:msg = printf('[%s] job_start %d - %s %s.', CurrentTime(), self.jobid,
                                   \   self.name, job_status(vimjob_object))
                    call self.log_event_message(l:msg)
                else
                    let l:msg = printf('[%s] job_start %d - %s %s.', CurrentTime(), self.jobid,
                                   \   self.name, job_status(vimjob_object))
                    call self.log_event_message(l:msg)
                    vimjob_object = ''
                endif
            else
                let l:msg = printf('[%s] job_start %d - %s failed, check the version %s feature please.',
                                \  CurrentTime(), self.jobid, self.name, v:version)
                call self.log_event_message(l:msg)
            endif
        endfunction

        function! instance.stop(...) closure
            let l:msg = printf("[%s] Stop job %s...", CurrentTime(), self.name)
            call self.log_event_message(l:msg)
            if !empty(vimjob_object)
                let retval = a:0 > 0 ? job_stop(vimjob_object, a:1) : job_stop(vimjob_object)
            endif
        endfunction

        function! instance.status() closure
            return empty(vimjob_object) ? '' : job_status(vimjob_object)
        endfunction

        function! instance.channel() closure
            if !empty(vimjob_object) && empty(vimjob_channel)
                let vimjob_channel = get_jobchannel(vimjob_object)
            endif
            return vimjob_channel
        endfunction

        function! instance.info() closure
            return empty(vimjob_object) ? {} : job_info(vimjob_object)
        endfunction

        function! instance.send(data) closure abort
            let ch = self.channel()
            call s:flush_vim_sendraw(ch, a:data, v:null)
        endfunction

        function! s:flush_vim_sendraw(ch, data, timer) closure abort
            if len(a:data) <= 1024
                call ch_sendraw(a:ch, a:data)
            else
                call ch_sendraw(a:ch, a:data[:1023])
                call timer_start(0, function('s:flush_vim_sendraw', [a:ch, a:data[1024:], v:null]))
            endif
        endfunction

        function! instance.wait(timeout) closure abort
            let start = reltime()
            if !has_key(instance.jobs, instance.jobid)
                return -3
            endif

            let timeout = a:timeout / 1000.0
            try
                while timeout < 0 || reltimefloat(reltime(start)) < timeout
                    let info = job_info(vimjob_object)
                    if info.status ==? 'dead'
                        return info.exitval
                    elseif info.status ==? 'fail'
                        return -3
                    endif
                    sleep 1m
                endwhile
            catch /^Vim:Interrupt$/
                return -2
            endtry
            return -1
        endfunction

        function! s:out_cb(job, data) dict abort
            let l:messages = split(a:data, "\n", 1)
            call self.log_event_message(l:messages)
            if has_key(self, 'on_stdout') && !empty(self.on_stdout)
                call self.on_stdout(self.jobid, l:messages, 'stdout')
            endif
        endfunction

        function! s:err_cb(job, data) dict abort
            let l:messages = split(a:data, "\n", 1)
            call self.log_event_message(l:messages)
            if has_key(self, 'on_stderr') && !empty(self.on_stderr)
                call self.on_stderr(self.jobid, l:messages, 'stderr')
            endif
        endfunction

        function! s:exit_cb(job, status) dict abort
            let l:message = printf("Exit. exitcode is %d.", a:status)
            call self.log_event_message(l:message)
            if has_key(self, 'on_exit') && !empty(self.on_exit)
                call self.on_exit(self.jobid, a:status, 'exit')
            endif
        endfunction

        return instance
    endfunction

    function! g:Job.Info()
        let inf = {}
        for key in keys(self.jobs)
            let inf = extend(inf, self.jobs[key].info())
        endfor
        return inf
    endfunction

    function! g:Job.Wait(timeout)
        let exitcode = 0
        let ret = []
        for key in keys(self.jobs)
            if l:exitcode !=? -2  " Not interrupted.
                let l:exitcode = self.jobs[key].wait(a:timeout)
            endif
            let l:ret += [l:exitcode]
        endfor
        return l:ret
    endfunction

    let &cpo = s:save_cpo
    unlet s:save_cpo
" }


" Jobwindow {

    let s:save_cpo = &cpo
    set cpo&vim

    " Jobwindow
    let s:Jobwindow = {
                   \   'inst': {}
                   \  }

    " Instance api
    function! s:Jobwindow.Instance(...)
        if empty(self.inst)
            " Properties default value set
            let defaults = {
                         \ 'limit_jobs': 8,
                         \ 'window_cmd': 'vertical topleft new',
                         \ }
            let instance = extend(self.inst, defaults, 'keep')
            if a:0 > 0 && type(a:1) ==? type({})
                if has_key(a:1, 'limit_jobs')
                    let instance.limit_jobs = a:1.limit_jobs
                endif
                if has_key(a:1, 'window_cmd')
                    let instance.window_cmd = a:1.window_cmd
                endif
            endif

            " private properties
            let remaining_jobs = 0
            let running_jobs = 0
            let process_ran = 0
            let status_icons = { 'ok': '✓', 'error': '✗', 'progress': '+' }
            " dictionary <jobid>-<processingflag>, Processing flag include: 'finished' 'failed'  'running' 'created'
            let processed_jobs = {}
            " dictionary <jobid>-<post process command string>
            let jobs_post_process = {}
            " dictionary <jobid>-<on finish string waitting execute>
            let jobs_on_finish = {}

            function! instance.add(name, cmd, cwd, ...) closure
                let l:job = g:Job.Create(a:cmd, {
                                  \  'name' : a:name,
                                  \  'cwd'  : empty(a:cwd) ? getcwd() : a:cwd,
                                  \  'on_stderr' : function('s:stdout_handler'),
                                  \  'on_stdout' : function('s:stdout_handler'),
                                  \  'on_exit'   : function('s:stdout_handler')
                                  \  })
                if l:job.jobid !=? g:Job.kInvalidJobid
                    let remaining_jobs += 1
                    let processed_jobs[l:job.jobid] = 'created'

                    let jobs_post_process[l:job.jobid] = ''
                    if a:0 >= 1 && type(a:1) ==? type('')
                        let jobs_post_process[l:job.jobid] = a:1
                    endif
                    if a:0 >= 2
                        let jobs_on_finish[l:job.jobid] = a:2
                    endif
                endif
            endfunction

            function! s:stdout_handler(jobid, message, event) closure abort
                if has_key(g:Job.jobs, a:jobid)
                    let l:job = g:Job.jobs[a:jobid]
                    if a:event !=? 'exit'
                        call s:update_job_status(l:job, 'progress', get(l:job.log(), -1, ' '))
                    else
                        " when job exit with message, job has failed
                        if a:message !=? 0
                            let processed_jobs[a:jobid] = 'failed'
                            let l:text = printf('Error. %s', get(l:job.log(), -1, ' '))
                            call s:update_job_status(l:job, 'error', l:text)
                            " the failed job has finished
                            call s:on_job_finished()
                        else
                            let processed_jobs[a:jobid] = 'finished'
                            let l:post_process = jobs_post_process[a:jobid]
                            if !empty(l:post_process)
                                call s:update_job_status(l:job, 'progress', 'Running post process hooks...')
                                if l:post_process[0] ==? ':'
                                    try
                                        call execute(l:post_process[1:])
                                        call s:update_job_status(l:job, 'ok', 'Finished')
                                    catch /.*/
                                        let processed_jobs[a:jobid] = 'failed'
                                        call s:update_job_status(l:job, 'error', printf('Error on post process hook - %s',
                                                              \  v:exception))
                                    endtry
                                    " the job has finished
                                    call s:on_job_finished()
                                else
                                    let l:hook = g:Job.Create(l:post_process, {
                                                      \  'name' : l:job.name,
                                                      \  'cwd'  : l:job.cwd,
                                                      \  'on_stderr' : function('s:hook_stdout_handler'),
                                                      \  'on_stdout' : function('s:hook_stdout_handler'),
                                                      \  'on_exit'   : function('s:hook_stdout_handler')
                                                      \  })
                                    if l:hook.jobid !=? g:Job.kInvalidJobid
                                        call s:start(l:hook)
                                    else
                                        let processed_jobs[a:jobid] = 'failed'
                                        call s:update_job_status(l:hook, 'error', printf('Error on post process hook - %s.',
                                                            \  'create new job(hook) failed, jobid invalid'))
                                        " the job has finished
                                        call s:on_job_finished()
                                    endif
                                endif
                            else
                                call s:update_job_status(l:job, 'ok', 'Finished')
                                " the job has finished
                                call s:on_job_finished()
                            endif

                            if remaining_jobs <=? 0
                                call s:run_jobs_on_finished()
                            endif
                        endif
                    endif
                endif
            endfunction

            function! s:hook_stdout_handler(jobid, message, event) closure abort
                if has_key(g:Job.jobs, a:jobid)
                    let l:job = g:Job.jobs[a:jobid]
                    if a:event !=? 'exit'
                        call s:update_job_status(l:job, 'progress', get(l:job.log(), -1, ' '))
                    else
                        " when job exit with message, job has failed
                        if a:message !=? 0
                            let l:text = printf('Error on hook. %s', get(l:job.log(), -1, ' '))
                            call s:update_job_status(l:job, 'error', l:text)
                            " the failed job has finished
                            call s:on_job_finished()
                        else
                            call s:update_job_status(l:job, 'ok', 'Finished.')
                            " the job has finished
                            call s:on_job_finished()
                        endif

                        if remaining_jobs <=? 0
                            call s:run_jobs_on_finished()
                        endif
                    endif
                endif
            endfunction

            function! s:on_job_finished() closure abort
                let remaining_jobs -= 1
                "Make sure it's not negative
                let remaining_jobs = max([0, remaining_jobs])
                let running_jobs -= 1
                "Make sure it's not negative
                let running_jobs = max([0, running_jobs])
                call s:update_top_status()
            endfunction

            let run_jobs_on_finished_called = 0
            function! s:run_jobs_on_finished() closure abort
                if run_jobs_on_finished_called ==? 0
                    let run_jobs_on_finished_called = 1
                    let l:scripts_warning = ''
                    for l:on_finish in values(jobs_on_finish)
                        if !empty(l:on_finish)
                            try
                                call execute(l:on_finish)
                            catch /.*/
                                let l:scripts_warning = printf('On execute finish scripts - %s.',
                                                            \  v:exception)
                                echohl WarningMsg | echomsg l:scripts_warning | echohl NONE
                            endtry
                        endif
                    endfor
                    if getbufvar(bufname('%'), '&filetype') ==? 'jobwindow'
                        call append('$', '')
                        if !empty(l:scripts_warning)
                            call append('$', 'Warning!!! '.l:scripts_warning.' See :message for detail.')
                        endif
                        call append('$', "Press 'E' on a job process line to see stdout in preview window.")
                        call append('$', "Press 'q' to quit this buffer.")
                        setlocal nomodifiable
                    endif
                endif
            endfunction

            function! s:clear() closure
                for l:jobid in keys(processed_jobs)
                    if has_key(g:Job.jobs, l:jobid)
                        call g:Job.jobs[l:jobid].stop()
                        call g:Job.jobs[l:jobid].clear()
                    endif
                endfor
                let remaining_jobs = 0
                let running_jobs = 0
                let process_ran = 0
                let processed_jobs = {}
                let jobs_post_process = {}
                let jobs_on_finish = {}

                let run_jobs_on_finished_called = 0
            endfunction

            function! instance.start() closure
                if remaining_jobs > 0
                    let process_ran = 1
                    call self.show()
                    call s:update_top_status()
                    for l:jobid in keys(processed_jobs)
                        if processed_jobs[l:jobid] !=? 'running'
                            call s:start(g:Job.jobs[l:jobid])
                            let processed_jobs[l:jobid] = 'running'
                        endif
                    endfor
                else
                    echomsg "Nothing to start"
                endif
            endfunction

            function! s:start(job) closure
                if instance.limit_jobs > 0
                    while running_jobs > instance.limit_jobs
                        silent exe 'redraw'
                        sleep 100m
                    endwhile
                    let running_jobs += 1
                endif
                if type(a:job) ==? type({}) && has_key(a:job, 'start')
                 \ && type(a:job.start) ==? type(function('tr'))
                    call a:job.start()
                endif
            endfunction

            function! instance.show() closure
                let l:is_current_jobwindow = &filetype ==? 'jobwindow'

                if !l:is_current_jobwindow
                    let l:jobwindow_window_numbers = filter(range(1, winnr('$')),
                                                         \  'getwinvar(v:val, "&filetype") ==? "jobwindow"')
                    if len(l:jobwindow_window_numbers) > 0
                        silent! exe printf('%dwincmd w', l:jobwindow_window_numbers[0])
                        let l:is_current_jobwindow = 1
                    endif
                endif

                if l:is_current_jobwindow
                    set modifiable
                    silent 1,$delete _
                else
                    exe self.window_cmd
                endif

                setf jobwindow
                setlocal modifiable buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell
                syntax clear
                syn match jobwindowCheck /^✓/
                syn match jobwindowPlus /^+/
                syn match jobwindowX /^✗/
                syn match jobwindowStar /^\s\s\*/
                syn match jobwindowStatus /\(^+.*—\)\@<=\s.*$/
                syn match jobwindowStatusSuccess /\(^✓.*—\)\@<=\s.*$/
                syn match jobwindowStatusError /\(^✗.*—\)\@<=\s.*$/
                syn match jobwindowStatusCommit /\(^\*.*—\)\@<=\s.*$/
                syn match jobwindowSha /\(\*\s\)\@<=[0-9a-f]\{4,}/
                syn match jobwindowRelDate /([^)]*)$/
                syn match jobwindowProgress /\(\[\)\@<=[\=]*/

                hi def link jobwindowPlus           Special
                hi def link jobwindowCheck          Function
                hi def link jobwindowX              WarningMsg
                hi def link jobwindowStar           Boolean
                hi def link jobwindowStatus         Constant
                hi def link jobwindowStatusCommit   Constant
                hi def link jobwindowStatusSuccess  Function
                hi def link jobwindowStatusError    WarningMsg
                hi def link jobwindowSha            Identifier
                hi def link jobwindowRelDate        Comment
                hi def link jobwindowProgress       Boolean
                nnoremap <silent><buffer> q :call <SID>quit()<CR>
                nnoremap <silent><buffer> E :call <SID>open_stdout()<CR>
                nnoremap <silent><buffer> <C-j> :call <SID>goto_job('next')<CR>
                nnoremap <silent><buffer> <C-k> :call <SID>goto_job('previous')<CR>
            endfunction

            function! s:update_top_status() closure
                let l:bar_length = 50
                let l:total = len(processed_jobs)
                let l:finished = l:total - remaining_jobs

                let l:bar_finished = float2nr(floor(str2float(l:bar_length) / str2float(l:total) * str2float(l:finished)))
                let l:bar_left = l:bar_length - l:bar_finished
                let l:bar = printf('[%s%s]', repeat('=', l:bar_finished), repeat('-', l:bar_left))

                let l:process_text = remaining_jobs > 0 ? 'Processing' : 'Finished'
                let l:finished_text = remaining_jobs > 0 ? '' : ' - Finished!'
                call setline(1, printf('%s jobs %d / %d%s', l:process_text, l:finished, l:total, l:finished_text))
                call setline(2, l:bar)
                return setline(3, '')
            endfunction

            function! s:update_job_status(job, icon_name, text) closure abort
                if type(a:job) ==? type({}) && has_key(a:job, 'name') && has_key(status_icons, a:icon_name)
                    if getbufvar(bufname('%'), '&filetype') ==? 'jobwindow'
                        let l:icons = join(values(status_icons), '\|')
                        let l:existing_line = search(printf('\(%s\)\s%s\s—', l:icons, a:job.name), 'n')
                        let l:job_status = printf('%s %s — %s', status_icons[a:icon_name], a:job.name, a:text)
                        if l:existing_line > 0
                            call setline(l:existing_line, l:job_status)
                        else
                            call append(3, l:job_status)
                        endif
                    endif
                endif
            endfunction

            function! s:quit() closure
                if remaining_jobs > 0
                    silent! exe 'redraw'
                    if confirm('Job process is in progress. Are you sure you want to quit?', '&Yes\n&No') ==? 1
                        call s:clear()
                        silent exe ':q!'
                    endif
                else
                    call s:clear()
                    silent exe ':q!'
                endif
            endfunction

            function! s:open_stdout(...) closure abort
                let l:is_hook = a:0 > 0
                " match the job name, and trim the name string
                let l:job_name = substitute(matchstr(getline('.'), '^.\s\zs[^—]*\ze'), '^\s*\(.\{-}\)\s*$', '\1', '')
                let l:the_job = ''
                for l:job in values(g:Job.jobs)
                    if l:job.name ==? l:job_name && has_key(processed_jobs, l:job.jobid)
                        let l:the_job = l:job
                    endif
                endfor

                if !empty(l:the_job)
                    let l:content = l:the_job.log()
                    if !empty(l:content)
                        silent exe 'pedit' l:job_name
                        wincmd p
                        setlocal previewwindow filetype=sh buftype=nofile nobuflisted modifiable
                        silent 1,$delete _
                        call append(0, l:content)
                        setlocal nomodifiable
                        nnoremap <silent><buffer> q :q<CR>
                    else
                        echo 'No stdout content to show.'
                    endif
                endif
            endfunction

            function! s:goto_job(dir) closure abort
                let l:icons = join(values(status_icons), '\|')
                let l:flag = a:dir ==? 'previous' ? 'b': ''
                return search(printf('^\(%s\)\s.*$', l:icons), l:flag)
            endfunction

        endif
        return self.inst
    endfunction

    let &cpo = s:save_cpo
    unlet s:save_cpo
" }


" General APIs {

    " Strip whitespace {
        function! StripTrailingWhitespace()
            " Preparation: save last search, and cursor position.
            let _s=@/
            let l = line(".")
            let c = col(".")
            " do the business:
            %s/\s\+$//e
            " clean up: restore previous search history, and cursor position
            let @/=_s
            call cursor(l, c)
        endfunction
    " }

    " Return directory {
        " Hold plug-in packages in directory of the function returned.
        function! PackHome()
            if !exists('g:packdir') && has("packages")
                let l:myvimrc = expand($MYVIMRC)
                let l:rcfilepath = strpart(l:myvimrc,
                                       \ 0,
                                       \ strridx(l:myvimrc, WINDOWS() ? '\' : '/'),
                                       \ )
                let &packpath = printf('%s,%s/.vim', &packpath, l:rcfilepath)
                let g:packdir = printf('%s/.vim/pack/dist', l:rcfilepath)
            endif
            return g:packdir
        endfunction

        " Hold project root path
        function! DirRoot(...)
            let g:dirroot = get(g:, 'dirroot', 
                        \ {'markers': ['.git', '.svn', '.project', '.root', '.hg'],
                        \ 'path':'' })
            if a:0 >= 1 && !empty(a:1)
                let g:dirroot.path = trim(expand(a:1))
            endif
            if g:dirroot.path != ''
                return g:dirroot.path
            endif
            let name = fnamemodify(bufname(), ':p')
            let finding = ''
            " iterate all markers
            for marker in g:dirroot.markers
                if marker != ''
                    " search as a file
                    let x = findfile(marker, name . '/;')
                    let x = (x == '')? '' : fnamemodify(x, ':p:h')
                    " search as a directory
                    let y = finddir(marker, name . '/;')
                    let y = (y == '')? '' : fnamemodify(y, ':p:h:h')
                    " which one is the nearest directory ?
                    let z = (strchars(x) > strchars(y))? x : y
                    " keep the nearest one in finding
                    let finding = (strchars(z) > strchars(finding))? z : finding
                endif
            endfor
            if finding == ''
                let g:dirroot.path = trim(fnamemodify(name, ':h'))
            else
                let g:dirroot.path = trim(fnamemodify(finding, ':p'))
            endif
            return g:dirroot.path
        endfunction
        augroup callDirRoot
            au!
            autocmd VimEnter * if &buftype !=? 'terminal' && bufname("")
                        \!~ "^\[A-Za-z0-9\]*://" | call DirRoot() | endif
        augroup END
        command! -nargs=? -complete=dir CD exec 'cd '.DirRoot(<q-args>)
    " }

    " Get current timestring {
        " Encapsulation the strftime function.
        " Usage: CurrentTime([format])
        function! CurrentTime(...)
            let fmt = '%Y-%m-%d %H:%M:%S'
            if a:0 >= 1
                let fmt = a:1
            endif
            return strftime(fmt)
        endfunction
        " Insert current time at the cursor position
        inoremap <C-D> <C-R>=CurrentTime()<CR>
    " }

    " Get selection string {
        " Used to get current selection string.
        function! Selection(range, arg)
            if a:arg != ''
              let expr = a:arg
            elseif a:range == 2
              let pos = getcurpos()
              let reg = getreg('v', 1, 1)
              let regt = getregtype('v')
              silent! normal! gv"vy
              let expr = @v
              call setpos('.', pos)
              call setreg('v', reg, regt)
            else
              let expr = expand('<cexpr>')
            endif
            return expr
        endfunction
        command! -range -nargs=* Edit exec 'edit '.Selection(<range>, <q-args>)
    " }

    " Exec & Redir command output {
        " This function output the result of the Ex command into a split scratch buffer
        function! Redir2Wnd(...)
          let cmd = join(a:000, ' ')
          let temp_reg = @"
          redir @"
          silent! execute cmd
          redir END
          let output = copy(@")
          let @" = temp_reg
          if empty(output)
              echo "---========== no output ==========---"
          else
            new
            setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
            put! = output
          endif
        endfunction
        command! -nargs=+ -complete=command Redir2Wnd call Redir2Wnd(<f-args>)
    " }

    " File(s) status description {
        " Get file size string value
        function! FileSize(...)
            if a:0 >= 1 && filereadable(expand(a:1))
                let size = getfsize(expand(a:1))
            else
                let size = getfsize(expand('%'))
            endif
            if size <= 0
                let fsizeStr = ''
            elseif size < 1024
                let fsizeStr = size.' B'
            elseif size < 1048576
                let fsizeStr = printf('%.1f KB', size/1024.0)
            elseif size < 1073741824
                let fsizeStr = printf('%.1f MB', size/1048576.0)
            else
                let fsizeStr = printf('%.1f GB', size/1073741824.0)
            endif
            return fsizeStr
        endfunction
        command! -nargs=? -complete=file Size echo FileSize(<q-args>)

        " Assign to g:filestat dictionary, usually used by statusline (FstatStr)
        " Usage: SetFilestat(statdesc1, statdesc2, ...)
        function! SetFilestat(...)
            let g:filestat = get(g:, 'filestat', {})
            let i = 0
            while i < argc() && i < a:0
                let fbufnr = bufnr("")
                if a:0 > 1
                    " Set file status descriptions one by one,
                    " function argv() return the file(s) list
                    let fbufnr = bufnr(fnameescape(argv(i)))
                endif
                let g:filestat[bufnr("")] = a:000[i]
                let i = i + 1
            endwhile
        endfunction
        " Used to set file(s) status description (echo argv() to see all files)
        " this user-command can be used in the shell command line like this:
        "     vim f1.h f2.h "+Filestat f1statdesc f2statdesc"
        "     vim f1.h f2.h -c "Filestat f1statdesc f2statdesc"
        command! -nargs=+ Filestat call SetFilestat(<f-args>)
    " }

    " Adjust guifont size {
        function! FontPattern()
            let pattern = ''
            if LINUX()
                let pattern = '\([^,]*\\ \)\([1-9][0-9]*\)'
            elseif OSX()
                let pattern = '\([^,]*:h\)\([1-9][0-9]*\)'
            elseif WINDOWS()
                let pattern = '\([^,]*:h\)\([1-9][0-9]*\)'
            endif
            return pattern
        endfunction

        function! CalcFontSize(font, size)
            let  delta = 0
            let amount = 0
            let pattern = FontPattern()
            if !empty(a:size)
                let prefix = strpart(a:size, 0, 1)
                if prefix ==? '+' || prefix ==? '-'
                    let delta = str2nr(a:size)
                endif
            endif
            if delta !=? 0
                let presize = substitute(a:font, pattern, '\2', '')
                let amount = presize + delta
            else
                let amount = str2nr(a:size)
            endif
            return substitute(a:font, pattern, '\1', '').amount
        endfunction

        " Turn up 2unit, call AdjustFontSize('+2')
        " Turn down 2unit, call AdjustFontSize('-2')
        " Directly set font size 18unit, call  AdjustFontSize('18')
        function! AdjustFontSize(size)
            if has('gui_running')
                let pattern = FontPattern()
                let &guifont = substitute(&guifont,
                            \pattern,
                            \'\=CalcFontSize(submatch(0), '.string(a:size).')',
                            \'g')
            endif
        endfunction

        " <Shift-Up> turn up 1unit, <Shift-Down> turn down 1unit
        nnoremap <silent> <S-Up> :call AdjustFontSize('+1')<CR>
        nnoremap <silent> <S-Down> :call AdjustFontSize('-1')<CR>
    " }


    " Toggle Terminal Window helper {
        " Open a new or previous Terminal Window
        function! TerminalOpen(...)
            let bid = get(t:, '__terminal_bid__', -1)
            let pos = 'rightbelow'    " where to open the terminal, default to 'rightbelow'.
            let height = 10
            let succeed = 0
            function! s:terminal_view(mode)
                if a:mode == 0
                    let w:__terminal_view__ = winsaveview()
                elseif exists('w:__terminal_view__')
                    call winrestview(w:__terminal_view__)
                    unlet w:__terminal_view__
                endif
            endfunc
            let uid = win_getid()
            keepalt noautocmd windo call s:terminal_view(0)
            keepalt noautocmd call win_gotoid(uid)
            if bid > 0
                let name = bufname(bid)
                if name != ''
                    let wid = bufwinnr(bid)
                    if wid < 0
                        exec pos . ' ' . height . 'split'
                        exec 'b '. bid
                        if mode() != 't'
                            if has('nvim')
                                startinsert
                            else
                                exec "normal! i"
                            endif
                        endif
                    else
                        exec "normal! ". wid . "\<c-w>w"
                    endif
                    let succeed = 1
                endif
            endif
            if has('nvim')
                let cd = haslocaldir()? 'lcd' : (haslocaldir(-1, 0)? 'tcd' : 'cd')
            else
                let cd = haslocaldir()? ((haslocaldir() == 1)? 'lcd' : 'tcd') : 'cd'
            endif
            if succeed == 0
                let command = &shell  "use default shell command to open terminal
                if has('nvim') && 0
                    for ii in range(winnr('$') + 8)
                        let info = nvim_win_get_config(0)
                        if has_key(info, 'anchor') == 0
                            break
                        endif
                        keepalt noautocmd exec "normal! \<c-w>w"
                    endfor
                    let uid = win_getid()
                endif
                let savedir = getcwd()
                if &bt == '' 
                    " change working directory to workdir, or DirRoot()
                    let workdir = (expand('%') == '')? getcwd() : expand('%:p:h')
                    silent execute cd . ' '. fnameescape(workdir)
                endif
                if has('nvim') == 0
                    exec pos . ' ' . height . 'split'
                    let opts = {'curwin':1, 'norestore':1, 'term_finish':'open'}
                    let opts.term_kill = 'term'  " set to 'term' to kill term session when exiting vim.
                    let opts.exit_cb = function('s:terminal_exit')
                    let bid = term_start(command, opts)
                    setlocal nonumber norelativenumber signcolumn=no
                    let jid = term_getjob(bid)
                    let b:__terminal_jid__ = jid
                else
                    exec pos . ' ' . height . 'split'
                    exec 'enew'
                    let opts = {}
                    let opts.on_exit = function('s:terminal_exit')
                    let jid = termopen(command, opts)
                    setlocal nonumber norelativenumber signcolumn=no
                    let b:__terminal_jid__ = jid
                    startinsert
                endif
                silent execute cd . ' '. fnameescape(savedir)
                let t:__terminal_bid__ = bufnr('')
                setlocal bufhidden=hide
                setlocal nobuflisted    " to hide terminal buffer in the buffer list.
                if get(g:, 'terminal_auto_insert', 0) != 0
                    if has('nvim') == 0
                        autocmd WinEnter <buffer> exec "normal! i"
                    else
                        autocmd WinEnter <buffer> startinsert
                    endif
                endif
            endif
            let x = win_getid()
            noautocmd windo call s:terminal_view(1)
            noautocmd call win_gotoid(uid)    " take care of previous window
            noautocmd call win_gotoid(x)
            "setlocal winfixheight
        endfunc

        " Hide Terminal Window
        function! TerminalClose()
            let bid = get(t:, '__terminal_bid__', -1)
            if bid < 0
                return
            endif
            let name = bufname(bid)
            if name == ''
                return
            endif
            let wid = bufwinnr(bid)
            if wid < 0
                return
            endif
            let sid = win_getid()
            noautocmd windo call s:terminal_view(0)
            call win_gotoid(sid)
            if wid != winnr()
                let uid = win_getid()
                exec "normal! ". wid . "\<c-w>w"
                close
                call win_gotoid(uid)
            else
                close
            endif
            let sid = win_getid()
            noautocmd windo call s:terminal_view(1)
            call win_gotoid(sid)
            let jid = getbufvar(bid, '__terminal_jid__', -1)
            let dead = 0
            if has('nvim') == 0
                if type(jid) == v:t_job
                    let dead = (job_status(jid) == 'dead')? 1 : 0
                endif
            else
                if jid >= 0
                    try
                        let pid = jobpid(jid)
                    catch /^Vim\%((\a\+)\)\=:E900:/
                        let dead = 1
                    endtry
                endif
            endif
            if dead
                exec 'bdelete! '. bid
            endif
        endfunc

        " Terminal job exit callback
        function! s:terminal_exit(...)
            "Set autoclose to 1 to close window if job process finished.
            let autoclose = 0
            if autoclose != 0
                let bid = get(t:, '__terminal_bid__', -1)
                let alive = 0
                if bid > 0 && bufname(bid) != ''
                    let alive = (bufwinnr(bid) > 0)? 1 : 0
                endif
                if alive
                    call TerminalClose()
                elseif bid > 0
                    exec 'bdelete! '.bid
                endif
            endif
        endfunc

        " Toggle Terminal Window open/close
        function! TerminalToggle()
            let bid = get(t:, '__terminal_bid__', -1)
            let alive = 0
            if bid > 0 && bufname(bid) != ''
                let alive = (bufwinnr(bid) > 0)? 1 : 0
            endif
            if alive == 0
                call TerminalOpen()
            else
                call TerminalClose()
            endif
        endfunc
        nnoremap <silent> <A-=> :call TerminalToggle()<CR>
        tnoremap <silent> <A-=> <C-W>:call TerminalToggle()<CR>

        function! Sendkeys(range, arg)
            let text = Selection(a:range, a:arg)
            let bid = get(t:, '__terminal_bid__', -1)
            let alive = 0
            if bid > 0 && bufname(bid) != ''
                let wid = bufwinnr(bid)
                if wid > 0
                    let alive = (bufname(bid) != '')? 1 : 0
                endif
            endif
            " check if buffer exists
            if alive
                " check if job stopped
                let jid = getbufvar(bid, '__terminal_jid__', -1)
                if has('nvim') == 0
                    if type(jid) == v:t_job
                        let alive = (job_status(jid) == 'dead')? 0 : 1
                    endif
                else
                    if jid >= 0
                        try
                            let pid = jobpid(jid)
                        catch /^Vim\%((\a\+)\)\=:E900:/
                            let alive = 0
                        endtry
                    endif
                endif
            endif
            let x = win_getid()
            if alive == 0
                call TerminalClose()
                call TerminalOpen()
                if has('nvim')
                    stopinsert
                endif
            endif
            let bid = get(t:, '__terminal_bid__', -1)
            if bid > 0
                let jid = getbufvar(bid, '__terminal_jid__', '')
                if string(jid) != ''
                    if has('nvim') == 0
                        let ch = job_getchannel(jid)
                        call ch_sendraw(ch, text)
                    else
                        call chansend(jid, text)
                    endif
                endif
            endif
            if has('nvim')
                let bid = get(t:, '__terminal_bid__', -1)
                if bid > 0 && bufname(bid) != ''
                    let wid = bufwinnr(bid)
                    if wid > 0
                        exec '' . wid . 'wincmd w'
                    endif
                    startinsert
                    stopinsert
                    exec 'normal! G'
                endif
            endif
            call win_gotoid(x)
        endfunction
        command! -range -nargs=* Sendkeys call Sendkeys(<range>, <q-args>)
    " }

    " Toggle Quickfix Window {
        function! QuickfixToggle()
            if !exists('g:quickfix_winids')
                let g:quickfix_winids = []
            endif
            let index = -1
            let i = 1
            while index ==? -1 && i <= winnr('$') 
                let j = 0
                while j < len(g:quickfix_winids)
                    if g:quickfix_winids[j] ==? win_getid(i)
                        let index = j
                        break
                    endif
                    let j = j + 1
                endwhile
                let i = i + 1
            endwhile
            if index >= 0 && index < len(g:quickfix_winids)
                cclose
                call remove(g:quickfix_winids, index)
            else
                copen
                call insert(g:quickfix_winids, win_getid())
            endif
        endfunction
        nnoremap <silent> Q :call QuickfixToggle()<CR>
    " }
" }


" Update on demand {
    " Compiled with packages support, using vim packages feature
    if has("packages")
        if (!isdirectory(PackHome().'/start') || !isdirectory(PackHome().'/opt'))
          \ && exists('*mkdir')
            call mkdir(PackHome().'/start', 'p')
            call mkdir(PackHome().'/opt', 'p')
        endif

        let c = get(g:, 'vim_plugin_dict',
            \ { 'start':[
            \               {
            \                   "name": "vim-colors-solarized",
            \                   "description": "Solarized Colorscheme for Vim",
            \                   "wget": "git clone --depth=1 git://github.com/altercation/vim-colors-solarized.git",
            \                   "post_process": ":exec 'helptags '.PackHome().'/start/vim-colors-solarized/doc'",
            \                   "on_finish": [
            \                                 "let pathofsolarized = PackHome().'/start/vim-colors-solarized'",
            \                                 "if isdirectory(pathofsolarized) && (!WINDOWS() || has('gui_running'))",
            \                                 "    syntax enable",
            \                                 "    set background=dark",
            \                                 "    let g:solarized_termcolors=256",
            \                                 "    let g:solarized_termtrans=1",
            \                                 "    let g:solarized_contrast='normal'",
            \                                 "    let g:solarized_visibility='normal'",
            \                                 "    exec 'colorscheme '.fnameescape('solarized')",
            \                                 "endif"
            \                                ]
            \               }
            \           ],
            \   'opt':[]
            \ })
        let g:vim_plugin_dict = c

        " Hold plug-in settings in 'vim-plugins.json' file
        try
            nnoremap <Leader>vp :execute 'vsplit' PackHome().'/vim-plugins.json'<CR>
            if !filereadable(PackHome().'/vim-plugins.json')
                if writefile([json_encode(g:vim_plugin_dict)], PackHome().'/vim-plugins.json', 'b') !=? 0
                    echohl WarningMsg | echomsg 'Write file (vim-plugins.json) failed.' | echohl NONE
                endif
            else
                let g:vim_plugin_dict = json_decode(join(readfile(PackHome().'/vim-plugins.json'), ''))
            endif
        catch /.*/
            nunmap <Leader>vp
            let error_msg = printf('Read/Write file (vim-plugins.json) exception - %s.', v:exception)
            echohl ErrorMsg | echomsg error_msg | echohl NONE
        endtry

        function! s:update_package()
            if has_key(g:vim_plugin_dict, 'start')
                let l:list = g:vim_plugin_dict.start
                for l:item in l:list
                    if !isdirectory(PackHome().'/start/'.l:item.name)
                        call s:Jobwindow.Instance().add(l:item.name, l:item.wget, PackHome().'/start',
                                                    \   l:item.post_process, l:item.on_finish)
                    endif
                endfor
            endif
            if has_key(g:vim_plugin_dict, 'opt')
                let l:list = g:vim_plugin_dict.opt
                for l:item in l:list
                    if !isdirectory(PackHome().'/opt/'.l:item.name)
                        call s:Jobwindow.Instance().add(l:item.name, l:item.wget, PackHome().'/opt',
                                                    \   l:item.post_process, l:item.on_finish)
                    endif
                endfor
            endif
            call s:Jobwindow.Instance().start()
        endfunction

        function! s:packadd_finished(...)
            let l:list = []
            if a:0 > 0 && a:1 ==? 'start'
                if has_key(g:vim_plugin_dict, 'start')
                    call extend(l:list, g:vim_plugin_dict.start)
                endif
            elseif a:0 > 0 && a:1 ==? 'opt'
                if has_key(g:vim_plugin_dict, 'opt')
                    call extend(l:list, g:vim_plugin_dict.opt)
                endif
            else
                if has_key(g:vim_plugin_dict, 'start')
                    call extend(l:list, g:vim_plugin_dict.start)
                endif
                if has_key(g:vim_plugin_dict, 'opt')
                    call extend(l:list, g:vim_plugin_dict.opt)
                endif
            endif
            if a:0 > 0 && a:1 !=? 'start' && a:1 !=? 'opt'
                call filter(l:list, 'has_key(v:val, "name") ?
                                  \  count(a:000, v:val.name) > 0 : has_key(v:val, "on_finish") ')
            endif
            for l:item in l:list
                let l:on_finish = has_key(l:item, 'on_finish') ? l:item.on_finish : ''
                if !empty(l:on_finish)
                    try
                        call execute(l:on_finish)
                    catch /.*/
                        let l:scripts_warning = printf('On execute finish scripts - %s.', v:exception)
                        echohl WarningMsg | echomsg l:scripts_warning | echohl NONE
                    endtry
                endif
            endfor
        endfunction

        " To manage vim plugins with dictionary g:vim_plugin_dict
        command! -nargs=0 -bar PackUpdate call s:update_package()
        " It is used to load on_finish script for plugin(s)
        " Usage: Packend plugin1name plugin2name
        command! -nargs=* -bar Packend call s:packadd_finished(<f-args>)

        " Load the 'start' group default
        Packend start
    endif


    " Update $MYVIMRC with RcUpdate command
    function! s:update_callback(command, tmp, event, jobid, data)
        if a:event ==? 'exit' && empty(a:data)
            let l:myvimrc = expand($MYVIMRC)
            let l:filename = strpart(l:myvimrc,
                                   \ strridx(l:myvimrc, WINDOWS() ? '\' : '/') + 1,
                                   \ strlen(l:myvimrc))
            let l:backup = !filereadable(l:myvimrc) || filereadable(l:myvimrc) &&
                        \  rename(l:myvimrc, l:myvimrc.'~') ==? 0
            if  l:backup && rename(a:tmp, l:myvimrc) ==? 0
                echomsg printf('Update %s succeed, try :source %s again', l:myvimrc, l:filename)
                call delete(l:myvimrc.'~')
                call timer_start(0,
                              \  {-> execute('source '.escape(l:myvimrc, ' '))}
                              \ )
            else
                echomsg printf('INFO: Save %s failed.', l:myvimrc)
                call delete(a:tmp)
                call rename(l:myvimrc.'~', l:myvimrc)
            endif
        else
            echomsg printf('INFO: [ %s ] %s', a:command, a:data)
        endif
    endfunction
    silent function! s:update()
        " Download https://raw.githubusercontent.com/libinwa/.dotfiles/master/_vimrc
        let l:src = "https://raw.githubusercontent.com/libinwa/.dotfiles/master/_vimrc"
        if has('job') && exists('*job_start') && exists('*job_status')
            let l:tmp = expand($MYVIMRC).'.tmp'
            let l:cmd = 'wget -O '.l:tmp.' --no-check-certificate '
            let l:job = job_start(printf('%s %s "%s %s"', &shell, &shellcmdflag, l:cmd, l:src),
                               \ {
                               \ 'out_cb' : function('s:update_callback', [l:cmd.' '.l:src, l:tmp, 'stdout']),
                               \ 'err_cb' : function('s:update_callback', [l:cmd.' '.l:src, l:tmp, 'stderr']),
                               \ 'exit_cb': function('s:update_callback', [l:cmd.' '.l:src, l:tmp, 'exit']),
                               \ 'mode': 'raw',
                               \ 'cwd': expand($HOME)
                               \ })
            if job_status(l:job) ==? 'run'
                echomsg printf('Download %s ...', l:src)
            else
                echohl ErrorMsg | echomsg printf('Download %s.', job_status(l:job)) | echohl NONE
            endif
        else
            let l:warning_msg = printf('Start download job failed, check the version %s feature please.',
                                     \ v:version)
            echohl WarningMsg | echomsg l:warning_msg | echohl NONE
        endif
    endfunction
    command! -nargs=0 -bar RcUpdate call s:update()
" }

" Use local vimrc if available {
    if filereadable(DirRoot().'/.vimrc.local')
        exec 'source '.DirRoot().'/.vimrc.local'
    elseif filereadable(DirRoot().'/_vimrc.local')
        exec 'source '.DirRoot().'/_vimrc.local'
    endif
" }
