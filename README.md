# vim dotfiles

This is my `.vim` 


## Plugins

### [vim-commmentary](https://vimawesome.com/plugin/commentary-vim)

Comment stuff out:

- `gcc` to comment out a line (takes a count)
- `gc` to comment out the target of a motion (for example, `gcap` to comment out a paragraph)
- `gc` in visual mode to comment out the selection
- `gc` in operator pending mode to target a comment.

You can also use it as a command:

- with a range like `:7,17Commentary`
- as part of a `:global` invocation like with `:g/TODO/Commentary`.


## Install

```
git clone git@github.com:fesaille/.vim.git ~/.vim
echo 'runtime vimrc' >> ~/.vimrc
cd ~/.vim && git submodule update --init --recursive
```

## Usage

### Plugin: Ack

```
:Ack [options] {pattern} [{directories}]
```

Links

## Links

[The ultimate Vim configuration]()
