## Get dotfiles

Git clone .dotfiles repository, like this:
`git clone --depth=1 https://github.com/libinwa/.dotfiles.git`

## Settings for vim

> My vimrc, plugins configured in vim-plugins.vim script file based vim-plug manager.

1. Switch your working directory to your `$HOME`
2. Copy file `.dotfiles/_vimrc` to your `$HOME`

## Navigating file system quickly with [fzf](https://github.com/junegunn/fzf) and [fd](https://github.com/sharkdp/fd)
After installation of fzf&fd executable files according to the official instructions for the OS.
Set these environment variables:
```
export FZF_DEFAULT_COMMAND="fd . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d . $HOME"
```
Done. You can now press:
- Press `<CTRL-T>` To fuzzily select a file or directory
- Press `<ALT-C>` To fuzzily change current directory
- Press `<CTRL-R>` To fuzzily search CLI history

> fd is designed to search for files by name, [rg](https://github.com/BurntSushi/ripgrep) is designed to search the contents of files. But ripgrep can be
> used to search for files by name rather than contents. So that, you can set environment variables as following:
```
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="rg --sort-files --files --null 2> /dev/null | xargs -0 dirname | uniq"
```

