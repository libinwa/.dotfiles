"/*********************************************************************
"- File name: _vimrc
"- Author: libin    Version: -       Date: 2018-03-05 11:56:09
"- Description:
"  1. Copy this file to `$HOME` to initialize vim.
"
"- Others:         // 其它内容的说明
"
"- History:
"    1. Date:2019-09-22 21:56:21 Add `:PackUpdate` to load packages.
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

    " Fixing: arrow-keys-type-capital-letters-instead-of-moving-the-cursor {
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

    set shortmess+=filmnrxoOtT      " Abbrev. of messages (set shortmess=atI   " 去掉欢迎界面)
    set autoindent                  " Indent at the same level of the previous line
    set autoread                    " 当文件在外部被修改，自动更新该文件
    "set autowrite                   " Write a file when leaving a modified buffer
    set backspace=indent,eol,start  " Backspace for dummies
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    set expandtab                   " Tabs are spaces, not tabs
    set hidden                      " Allow buffer switching without saving
    set history=1000                " Store a ton of history (default is 20)
    set hlsearch                    " Highlight search terms
    set ignorecase                  " Case insensitive search
    set incsearch                   " `set noincsearch` " 在输入要搜索的文字时，取消实时匹配
    set iskeyword-=#                " '#' is an end of word designator
    set iskeyword-=-                " '-' is an end of word designator
    set iskeyword-=.                " '.' is an end of word designator
    "set matchpairs+=<:>             " Match, to be used with %
    set mouse=a                     " Enable mouse usage
    set mousehide                   " Hide the mouse cursor while typing
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set nowrap                      " Do not wrap long lines
    set number                      " Line numbers on
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    set path+=**                    " 检索file_in_path时递归查找子目录
    set relativenumber              " Line relative numbers on
    "set spell                       " Spell checking on
    set shiftwidth=2                " Use indents of 2 spaces
    set showmatch                   " Show matching brackets/parenthesis
    set smartcase                   " Case sensitive when uc present
    set smartindent                 " Enable smart indent
    set smarttab                    " 指定按一次backspace就删除shiftwidth宽度
    set softtabstop=2               " Let backspace delete indent
    set tabpagemax=15               " Only show 15 tabs
    set tabstop=2                   " An indentation every 2 columns
    "set vb t_vb=                    " 关闭提示音
    set viewoptions=folds,options,cursor,unix,slash    " Better Unix / Windows compatibility
    set virtualedit=onemore         " Allow for cursor beyond last character
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.

    set nofoldenable                " 禁用折叠 `set foldenable` " 启用折叠
    set foldmethod=indent           " indent 折叠方式 `set foldmethod=marker` " marker 折叠方式
    " 常规模式下用空格键来开关光标行所在折叠（注：zR 展开所有折叠，zM 关闭所有折叠）
    nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

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

    " Auto change directory to the current file directory when buffer entered.
    augroup chDir
        autocmd!
        autocmd BufEnter * if &buftype !=? 'terminal' && bufname("") !~ "^\[A-Za-z0-9\]*://"
                    \| try | lcd %:p:h | catch /^Vim\%((\a\+)\)\=:E/ | endtry | endif
    augroup END

    " Instead of using the $MYVIMRC, add 'g:thisrc' to avoid path confused.
    let g:thisrc = get(g:, 'thisrc', resolve(expand('<sfile>:p')))
    " Hold plug-in packages in the directory following function returned.
    silent function! PackHome()
        let packdir = printf('%s/.vim/plugged', fnamemodify(g:thisrc, ':h'))
        if !isdirectory(packdir) && exists('*mkdir')
            call mkdir(packdir, 'p')
        endif
        return packdir
    endfunction
    " Set packpath option.
    if has("packages")
        let &packpath = printf('%s,%s', &packpath, PackHome())
    endif

    " Enable persistent_undo
    if has('persistent_undo')
        set undofile                " So is persistent undo ...
        set undolevels=1000         " Maximum number of changes that can be undone
        set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        " Put undofile in the unified directory
        let uDir = printf('%s/.vim/undo', fnamemodify(g:thisrc, ':h'))
        if !isdirectory(uDir) && exists('*mkdir')
            call mkdir(uDir, 'p', 0o700)
        endif
        let &undodir = printf('%s,%s', uDir, &undodir)
    endif

    " To enable backup, uncomments the next line.
    "let g:opt_backup_enable = 1
    if exists('g:opt_backup_enable')
        set backup                  " Backups are nice ...
    else
        set nobackup                " 设置无备份文件
        set writebackup             " 保存文件前建立备份，保存成功后删除该备份
        set noswapfile              " 设置无临时文件
    endif

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session. To disable the restoration, uncomments the next line.
    "let g:opt_no_restore_cursor = 1
    if !exists('g:opt_no_restore_cursor')
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

    " Jumping with tags {
        " A tag is an identifier that appears in a "tags" file.  It is a sort of label
        " that can be jumped to. The "tags" file should be generated by a tool like
        " "ctags -R -c++-kinds=+px -fields=+iaS -extra=+q" before the ":tag" commands
        " can be used. With the ":tag" command the cursor will be positioned on the tag.
        " With the CTRL-] command, the keyword on which the cursor is standing is used
        " as the tag.  If the cursor is not on a keyword, the first keyword to the right
        " of the cursor is used. For more infomation, please ":h tags"
        "
        " The tool of "gtags" (or "cscope") is a tagging system which works the same way
        " across diverse environments. Plugins which intergrated the tagging system can be
        " easy to use.
        "
        " 以下设置索引文件名为".tags",以小数点开头更便于识别。后面的分号不要去掉!!
        " 加`;`表示若当前编辑的文件所在目录中不存在".tags"，则在其父目录中查找".tags"直至根目录。
        set tags=./.tags;

        " 缺省索引文件文件 "tags", 放最低优先级
        set tags+=tags
    " }

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    augroup gitcommitEditMSG
        autocmd!
        autocmd FileType gitcommit autocmd! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
    augroup END
" }


" Key Mappings {
    " The default Leader is '\', you can set a new key to override the default.
    let g:mapleader = '\'
    " 注：若配"<Leader>"为"\"，在常规模式下，如<Leader>t是按"\"键加"t"键，不是同时按而是先按"\"键
    " 后按"t"键，间隔在一秒内，再如<Leader>cM是先按"\"键再按"c"又再按"M"键

    " 这个mapping会为你的左手减轻很多负担
    inoremap jk <ESC>
    nnoremap ,q <Cmd>bdelete<CR>
    nnoremap ,p <Cmd>bprevious<CR>
    nnoremap ,n <Cmd>bnext<CR>
    nnoremap ,o <Cmd>b#<CR>
    nnoremap ,` <Cmd>terminal ++curwin<CR>
    if exists('&termwinkey') | set termwinkey=<C-L> | tnoremap <C-L>p <Cmd>tabprevious<CR> | endif
    nnoremap <Leader>w <C-W>
    nnoremap <Tab><Tab> :tab split<CR>  " Opens current buffer in new tab page
    nnoremap <Tab>n :tabnext<CR>
    nnoremap <Tab>p :tabprevious<CR>

    " Backspace to cancel match-highlight provisionally
    nnoremap <BS> :noh<CR>
    " 在新的分屏中打开我的 ~/.vimrc 文件
    nnoremap <Leader>ve :vsplit $MYVIMRC<CR>
    " 重读我的 ~/.vimrc 文件
    nnoremap <Leader>sv :source $MYVIMRC<CR>
    " Open file under the cursor
    nnoremap gf :vertical wincmd f<CR>
    " 常规模式下输入<Leader>cM清除行尾^M符号
    nnoremap <Leader>cM :%s/\r$//g<CR>:noh<CR>
    " New stmt to insert keys into register, try: "w<leader>mm
    nnoremap <leader>mm :<C-U><C-R><C-R>='let @'. v:register .' = '. string(getreg(v:register))<CR><C-F><LEFT>
" }


" UI Settings {
    " Set a dark background, allow to toggle background
    set background=dark
    function! ToggleBG()
        let tbg = &background
        " Inversion
        if tbg ==? "dark"
            set background=light
        else
            set background=dark
        endif
    endfunction
    nnoremap <Leader>bg :call ToggleBG()<CR>

    " 启用每行超过某一字符总数后给予字符变化提示（字体变蓝加下划线等），不启用就注释掉
    augroup lineWidth
        autocmd!
        autocmd BufWinEnter * let w:m2 = matchadd('Underlined',
                    \ printf('\%%>%dv.\+', float2nr(128 * 1.382)), -1)
    augroup END

    set winminheight=0              " Windows can be 0 line high
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    set fillchars=vert:\ ,fold:-    " Set characters to fill the statuslines and vertical separators.
                                    " The fillchars option default string is "vert:|,fold:-"
    set t_Co=256                    " Enable 256 colors to make xterm/win32 vim shine
    set cursorline                  " Highlight current line
    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set noshowmode                  " Don't display the current mode

    set cmdheight=2                 " Set command line height as 2，default 1
    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2                         " Switch status line on
        let g:theModes={ 'n'  : 'Normal', 'no' : 'Normal·Operator Pending', 'v'  : 'Visual', 'V'  : 'V·Line', '^V' : 'V·Block', 's'  : 'Select', 'S'  : 'S·Line', '^S' : 'S·Block',
              \ 'i'  : 'Insert', 'R'  : 'Replace', 'Rv' : 'V·Replace', 'c'  : 'Command', 'cv' : 'Vim Ex', 'ce' : 'Ex', 'r'  : 'Prompt', 'rm' : 'More', 'r?' : 'Confirm', '!'  : 'Shell',
              \ 't'  : 'Terminal' }
        silent function! CurrentMode()
          return has_key(g:theModes, mode()) ? toupper(g:theModes[mode()]) : mode()
        endfunction
        silent function! FencStr()
            let fencStr = empty(&fenc) ? &enc : &fenc
            let bombStr = (exists('+bomb') && &bomb) ? ' with BOM' : ''
            return fencStr.bombStr
        endfunction
        silent function! BuffersListed()
          return len(getbufinfo({'buflisted':1}))
        endfunction
        silent function! GitBranch()
          return exists('*FugitiveHead')? FugitiveHead() : ''
        endfunction

        " Broken down into includeable segments
        set statusline=%<%#WildMenu#\ %{&paste?'PASTE':CurrentMode()}\ %*
        set statusline+=%<%#Pmenu#\ %{GitBranch()!=#''?GitBranch().'\ \|':''}\ %*
        set statusline+=%<%#Pmenu#\%f\ %*
        set statusline+=%<%#Pmenu#\|\ %w%m%r[b%n/%{BuffersListed()}]\ %*
        set statusline+=%<%#SignColumn#\ %{filereadable(@%)?SizeofFile():''}\ %*
        set statusline+=%<%#SignColumn#\ %=    " Right side
        set statusline+=%<%#SignColumn#\ %{FencStr()},%{&ff}/%{&ft!=#''?&ft:'no\ ft'}\ %*
        set statusline+=%<%#CursorLine#\ %p%%\ %*                         " Right aligned file nav info
        set statusline+=%<%#Visual#\ %(%3l:%-2c\ %)%*
    endif

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
            set guifont=Inconsolata\ 14,Consolas\ Regular\ 12
        elseif OSX()
            set guifont=Inconsolata:h14,Consolas\ Regular:h12
        elseif WINDOWS()
            set guifont=Inconsolata:h14,Consolas:h10
        endif
    endif
" }


" General APIs {
    " Twice the Result with Half the Effort {
        function! StripTrailingWhitespaceTrimming(begin, end)
            " Preparation: save last search, and cursor position.
            let _s=@/
            let l = line(".")
            let c = col(".")
            " do the business:  %s/\s\+$//e
            silent! exec printf("%d,%ds/\\s\\+$//e", a:begin, a:end)
            " clean up: restore previous search history, and cursor position
            let @/=_s
            call cursor(l, c)
        endfunction
        command! -range=% -nargs=0 Trim call StripTrailingWhitespaceTrimming(<line1>, <line2>)

        function! CurrentTime(...)
            let fmt = '%Y-%m-%d %H:%M:%S'
            if a:0 >= 1
                let fmt = a:1
            endif
            return strftime(fmt)
        endfunction
        " Insert current time at the cursor position
        inoremap <C-D> <C-R>=CurrentTime()<CR>

        function! SizeofFile(...)
            "           ---0------1-----2-----3--
            let unit = ['Bytes', 'KB', 'MB', 'GB']
            let size = getfsize(expand('%'))
            if a:0 >= 1 && filereadable(expand(a:1))
                let size = getfsize(expand(a:1))
            endif
            let p = 0 | let l = size
            while l > 1024 | let l = l / 1024.0 | let p = p + 1 | endwhile
            let readableSize = printf('%d %s', size, unit[0])
            if p > 0 | let readableSize = printf('%d %s, %.2f %s', size, unit[0], l, unit[p]) | endif
            return readableSize
        endfunction
        command! -nargs=? -complete=file Size echo SizeofFile(<q-args>)

        " Redirect the CMDs message into the output window.
        function! Redirect(...)
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
            setf OutputWindow
            syntax clear
            setlocal modifiable buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell
            nnoremap <silent><buffer> q :q!<CR>
            put! = output
            call append('$', "---")
            call append('$', "Press 'q' to quit this buffer.")
          endif
        endfunction
        command! -nargs=+ -complete=command Red call Redirect(<f-args>)

        " Toggle the Quickfix window
        function! QuickfixToggle()
            let g:quickfix_winids = get(g:, 'quickfix_winids', [])
            let index = -1 | let i = 1
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

        " Wipe out the hidden or unloaded (after `:bdelete`) buffers
        function! Bwipeout(all) abort
            let l:buffers = filter(getbufinfo(), {_, v -> !v.loaded || v.hidden})
            if !empty(l:buffers)
                execute a:all? 'bwipeout!':'bwipeout' join(map(l:buffers, {_, v -> v.bufnr}))
            endif
        endfunction
        command! -bar -bang Bw call Bwipeout(<bang>0)
    " }

    " For the Projects {
        " Return the project root directory.
        silent function! ProjectDir(...)
            let g:theProject = get(g:, 'theProject', {'markers': ['.git', '.svn', '.vs', '.vscode', '.editorconfig'], 'path':'' })
            if a:0 >= 1 && type(a:1) == type("") && !empty(a:1)
              let abspath = isabsolutepath(a:1)? a:1 : getcwd().'/'.a:1
              let g:theProject.path = trim(simplify(expand(abspath)))
            endif
            if g:theProject.path == ''
                let name = fnamemodify(bufname(), ':p')
                let g:theProject.path = trim(fnamemodify(name, ':h'))
                let finding = ''
                " iterate all markers
                for marker in g:theProject.markers
                    " search as a file
                    let x = findfile(marker, name . '/;')   " Upward search
                    let x = (x == '')? '' : fnamemodify(x, ':p:h')
                    " search as a directory
                    let y = finddir(marker, name . '/;')
                    let y = (y == '')? '' : fnamemodify(y, ':p:h:h')
                    " which one is the nearest directory ?
                    let z = (strchars(x) > strchars(y))? x : y
                    " keep the nearest one in finding
                    let finding = (strchars(z) > strchars(finding))? z : finding
                endfor
                if finding != ''
                    let g:theProject.path = trim(fnamemodify(finding, ':p'))
                endif
            endif
            return g:theProject.path
        endfunction

        " Sync files between local source and destination (ssh config is for remote).
        function! SyncFiles(src)
          let choices='' | let i = 1 | let h = '' | let hosts=['NA']
          echo 'Hosts:' | echo printf(' [%d] local', i) | call add(hosts, h) | let i+=1
          let sshconfig = expand('$HOME/.ssh/config')
          if filereadable(sshconfig)
            let items = filter(readfile(sshconfig), 'v:val =~ "^Host\\s\\+"')
            for h in items
              let h = substitute(h, '^\s*Host\s\+\(.*\)\s*', '\1', 'g')
              echo printf(' [%d] %s', i, h) | call add(hosts, h.':') | let i+=1
            endfor
          endif
          let host = get(hosts, input("To:"), 'NA') | let dfmt = a:src.' '.host.'%s'
          if host ==# 'NA' | let host = get(hosts, input("From:"), 'NA') | let dfmt = host.'%s '.a:src | endif
          let dest = input("destination:")
          if host != 'NA' && dest != ''
            if executable('rsync')
              let cmd = printf('rsync -zahvvv --stats '.dfmt, dest)
              let fltconfig = findfile('rsync_filter.txt', '**/*')  " Downward search
              if fltconfig != '' | let cmd = cmd.' --filter="merge '.fltconfig.'"' | endif
              call JobStart('rsync', cmd)
            elseif executable('scp')
              call JobStart('scp', printf("scp -Cprv ".dfmt, dest))
            else
              echohl ErrorMsg | echomsg printf('No executable sync tool.') | echohl NONE
            endif
          endif
        endfunction
        command! -nargs=+ -complete=file Sync call SyncFiles(<q-args>)

        augroup ckProjectDir
            au!
            autocmd VimEnter * if &buftype !=? 'terminal' &&
                        \bufname("") !~ "^\[A-Za-z0-9\]*://" | call ProjectDir() | endif
        augroup END
        command! -nargs=? -complete=dir CD let g:theProject.path='' | exec 'cd '.ProjectDir(<q-args>) | echo ProjectDir()
    " }

    " Git Commands {
        function! GitSelection(prefix, suffix, range, arg)
            let l:midfix = '-L'.line(".").',+1'
            if    a:arg > 0 | let l:midfix = '-L'.line(".").',+'.a:arg      | endif
            if a:range == 2 | let l:midfix = '-L'.line("'<").','.line("'>") | endif
            call JobStart(a:prefix, printf("%s %s%s", a:prefix, l:midfix, a:suffix))
        endfunction
        command! -range -nargs=? -complete=command GitLog call GitSelection('git log', ':'.expand('%'), <range>, <q-args>)
        command! -range -nargs=? -complete=command GitBlame call GitSelection('git blame', ' -- '.expand('%'), <range>, <q-args>)
    " }

    " Wrapper of the CLIs job control {
        silent function! JobCallback(jid, cb, event, channel, data)
            if !empty(a:cb) && type(a:cb) ==? type(function("tr"))
                call a:cb(a:jid, a:event, a:channel, a:data)
            elseif !empty(a:data)
                let l:buf = bufnr('^○●○ '.a:jid) | let l:wid = bufwinid(l:buf)
                if l:wid ==? -1
                    silent execute 'new ○●○ '.a:jid
                    syntax clear
                    setlocal modifiable buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell
                    let b:job = ch_getjob(a:channel) | let b:ss = 0   " Hold the job and scrolling switch
                    nnoremap <silent><buffer> q :call job_stop(b:job, 'kill')<CR>
                    nnoremap <silent><buffer><Leader>ss :let b:ss = (b:ss != 0)? 0 : 1<CR>
                endif
                call setbufvar(l:buf, 'job', ch_getjob(a:channel))
                call setbufvar(l:buf, '&modifiable', 1) | call appendbufline(l:buf, '$', a:data)
                call setbufvar(l:buf, '&modified', 0) | call setbufvar(l:buf, '&modifiable', 0)
                if getbufvar(l:buf, 'ss') != 0 | call win_gotoid(l:wid) | call cursor('$', 0) | endif
            endif
        endfunction

        " Encapsulate the job_start function. Usage: JobStart(jid, cmd, [cwd], [callback])
        silent function! JobStart(...)
            let l:jid = trim(get(a:000, 0, [])) | let l:cmd = trim(get(a:000, 1, []))
            let l:cwd = trim(get(a:000, 2, getcwd())) | let l:Cb = get(a:000, 3, {})
            if has('job') && exists('*job_start') && exists('*job_status')
                let l:job = job_start(printf('%s %s "%s"', &shell, &shellcmdflag, l:cmd),
                                \ {
                                \ 'out_cb' : function('JobCallback', [l:jid, l:Cb, 'stdout']),
                                \ 'err_cb' : function('JobCallback', [l:jid, l:Cb, 'stderr']),
                                \ 'exit_cb': function('JobCallback', [l:jid, l:Cb, 'exit']),
                                \ 'mode': 'nl',
                                \ 'cwd': expand(l:cwd)
                                \ })
                if job_status(l:job) !=? 'run'
                    echohl ErrorMsg | echomsg printf('Job {%s} %s.', l:cmd, job_status(l:job)) | echohl NONE
                endif
            else
                let l:warning_msg = printf('Start job failed, check the version %s feature please.', v:version)
                echohl WarningMsg | echomsg l:warning_msg | echohl NONE
            endif
        endfunction
        command! -nargs=+ -complete=file_in_path Start call JobStart(strpart(<q-args>, 0, 8), <q-args>)

        " Use QuickFix when calling JobStart with Quick command.
        silent function! SetQfList(jid, event, channel, data)
          call setqflist([], 'a', { 'title': a:jid, 'lines': [a:data]})
        endfunction
        command! -nargs=+ -complete=file_in_path Quick call setqflist([], 'r') |
              \ call JobStart(strpart(<q-args>, 0, 8), <q-args>, getcwd(), function('SetQfList'))
    " }
" }


" For Plugins {
    " Update vim-plug and load all packages
    silent function! VimPlugUpdate()
        let l:filename = PackHome().'/plug.vim'
        if !filereadable(l:filename)
            let l:uri = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
            call JobStart('Download vim-plug', 'curl -vLs -o '.l:filename.' '.l:uri, PackHome())
        else
            " Load vim-plugins.vim based on `vim-plug`
            exec 'source '.l:filename
            nnoremap <Leader>vp :execute 'vsplit' PackHome().'/vim-plugins.vim'<CR>
            if filereadable(PackHome().'/vim-plugins.vim')
                exec 'source '.PackHome().'/vim-plugins.vim'
            else
                let l:tmplst = [ '" Specify a directory for plugins',
                            \ 'call plug#begin(PackHome())',
                            \ '"',
                            \ '" List the plugins with Plug commands',
                            \ 'Plug ''junegunn/fzf''',
                            \ 'Plug ''junegunn/fzf.vim''',
                            \ 'call plug#end()',
                            \ '" INITIALIZATION OF PLUGINs']
                if writefile(l:tmplst, PackHome().'/vim-plugins.vim', 'b') !=? 0
                    echohl WarningMsg | echomsg 'Write file (vim-plugins.vim) failed.' | echohl NONE
                    nunmap <Leader>vp
                endif
            endif
        endif
    endfunction
    command! -nargs=0 -bar PackUpdate call VimPlugUpdate()
" }

" Use local vimrc if available {
    if filereadable(ProjectDir().'/.vimrc.local')
        exec 'source '.ProjectDir().'/.vimrc.local'
    endif
" }

" Call `VimPlugUpdate` method to load all packages
PackUpdate
