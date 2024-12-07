# Highlight preset color values in Liquid Prompt config/preset/theme files

Liquid Prompt uses the function `lp_terminal_format` documented in "docs/functions/public.rst" to apply ANSI escape code.

But, this complicated function takes 6 arguments (fg, bg, bold, underline, fallback_fg, fallback_bg), including 4 accepting ANSI escape codes for colors, there is no way to highlight those values in any vanilla code/text editor.

**The Vim/Neovim plugin [vim-hexokinase](https://github.com/RRethy/vim-hexokinase) provides a way to match custom palettes of colors with patterns in the text.**

This folder provides 3 new palettes to extend [vim-hexokinase](https://github.com/RRethy/vim-hexokinase):

  - lpcolorsBg2hexTable.json: help highlighting the 'bg' argument when using `lp_terminal_format`.
  - lpcolorsFg2hexTable.json: help highlighting the 'fg' argument when using `lp_terminal_format`.
  - xtermcolors2hexTable.json: optional, correct ANSI colors modified by the terminal emulator configuration.

## Requirements

- Vim or Neovim with `:h 'termguicolors'` turned on.
- ISO-8613-3 compatible terminal for compatibility with 'termguicolors'.
- Golang to [compile](https://golang.org/doc/install) vim-hexokinase.
- xtermcontrol to get the terminal ANSI colors.

### Adjust the ANSI colors to your terminal settings

The palette files are build following instructions in vim-hexokinase's doc section "[Custom Patterns via Palettes](https://github.com/RRethy/vim-hexokinase/blob/master/doc/hexokinase.txt#L175)".

I created the list of values using the script at [mardlo's Gist](https://gist.github.com/marslo/8e4e1988de79957deb12f0eecec588ec#file-color-utils-sh-L101), but the 16 first colors are dependent on your terminal configuration, those could be set from the terminal settings or system wide like for URxvt which uses Xressources.

To adjust the colors 0 to 15 in those 3 JSON files you can run the bash script `update_terminal_colors.sh` from the same folder. It get the current colors with xtermcontrol and update the patterns with sed.

## Installation

1. Install Golang.
2. Install Vim or Neovim.
3. Install xtermcontrol
4. Install vim-hexokinase:

Example for VIM8+:

``` bash
# inside vim default config folder
cd ~/.vimrc
# init a subfolder for plugins
mkdir pack/
cd pack/
git init
# copy vim-hexokinase and its submodules
git submodule add --depth=1 https://github.com/RRethy/vim-hexokinase ui/start/vim-hexokinase
cd ui/start/vim-hexokinase
git submodule init
git submodule update
# compile with go
cd hexokinase/
go build
```

4. Copy the extension:

Example for VIM8+:

``` bash
mkdir ~/.vimrc/assets/vim-hexokinase/
cp contrib/tools/vim-hexokinase/* ~/.vimrc/assets/vim-hexokinase/*
```

5. Update ANSI colors:

``` bash
bash update_terminal_colors.sh
```

6. Configure Vim or Neovim:

Example `~/.vimrc` file for VIM8+:

``` vim
" BASICS
" ~~~~~~
set encoding=UTF-8 " force utf8
set updatetime=100 " for better async update
set ttimeout " set a timeout for key sequence, control delay of vim-which-key buffer too
set ttimeoutlen=200

" COLORS
" ~~~~~~
" set for 24bit colors terminal
" warn: use guibg & guifg even for terminal
set termguicolors
" 24bit compatiility with tmux
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" vim-hexokinase: configuration
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" an empty g:Hexokinase_ftEnabled will disable it by default
let g:Hexokinase_ftEnabled = []
let g:Hexokinase_highlighters = [
  \  'backgroundfull'
  \ ]
let g:Hexokinase_palettes = [
  \  expand($HOME).'/.config/vim/assets/vim-hexokinase/xtermcolors2hexTable.json',
  \  expand($HOME).'/.vimrc/assets/vim-hexokinase/lpcolorsBg2hexTable.json',
  \  expand($HOME).'/.vimrc/assets/vim-hexokinase/lpcolorsFg2hexTable.json'
  \ ]
let g:Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla,colour_names'

" vim-hexokinase: Keymap to toggle on/off
nnoremap <silent> <Leader>aC :HexokinaseToggle<CR>

" Plugins & HelpTags
" ~~~~~~~~~~~~~~~~~~
" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

" vi: ft=vim
```

## License

Distributed under the GNU Affero General Public License version 3.

