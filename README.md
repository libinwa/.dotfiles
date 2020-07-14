## Get my dotfiles

Git clone .dotfiles repository, like this:
`git clone --depth=1 https://github.com/libinwa/.dotfiles.git`

## Settings for vim

> My personal vimrc,   support plugins configured in vim-plugins.json file

1. Switch your working directory to your `$HOME`
2. Copy file `.dotfiles/_vimrc` to your `$HOME`

Enjoy your Vim.

NOTE:
* `PackHome().'/vim-plugins.json'` is used to manage plugin(s). For the json `key-value` format,
please refer to the default `vim-plugins.json` file. If the default `vim-plugins.json` file not exists,
it will be created by the *_vimrc* script.
* `:PackUpdate` to update/download plugin(s) configured in the json file.
* `:Packend` to reload all plugin `on_finish` script configured in the json file.
* `:Packend start/opt` to reload start/opt plugin `on_finish` script configured in the json file.
* `:Packend plugin1name plugin2name` to load `on_finish` script configured in the json file for plugin(s) .

You can easily execute `:RcUpdate` in Ex mode to update *_vimrc* file.

How to exit the Vim editor?
The answer is "type :quit<Enter> to quit VIM"


## Settings for fzf
1. Download fzf executable program.
2. Clone fzf repository (include scripts interface) to $HOME, like 
`git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf`

> fzfз vim, based `vim-plugins.json` file: 
>- `PackUpdate` command not only clone fzf.vim repo as a plugin, but 
also clone fzf repo to `PackHome()`. 
>- `Packend` command will source `PackHome()...fzf/plugin/fzf.vim` first, and then 
check `$HOME/.fzf` and `source $HOME/.fzf/plugin/fzf.vim` to finish fzf initialize.
