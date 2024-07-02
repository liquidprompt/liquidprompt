# Highlighting color values in theme/preset files

Theme files for Liquid Prompt use the function `lp_terminal_format` documented in "docs/functions/public.rst".

The issue with this format is that this function takes 6 arguments (fg, bg, bold, underline, fallback_fg, fallback_bg), including 4 which are integers representing the ANSI escape code for colors, there is no way to highlight those values in any vanilla code/text editor.

Being a Vim user, I found out that the plugin [vim-hexokinase](https://github.com/RRethy/vim-hexokinase) does provide a way to match custom palettes of colors with patterns in the text.

This folder provides 2 JSON files containing custom values for vim-hexokinase, able to highlight the `fg` and `bg` arguments in a `lp_terminal_format` function.

## Requirements

- Vim or Neovim with `:h 'termguicolors'` turned on.
- ISO-8613-3 compatible terminal to use 'termguicolors'.
- Golang installed to compile vim-hexokinase: https://golang.org/doc/install.

## Adjusting the colors in the JSON files

The 2 JSON files are build following instructions in vim-hexokinase's doc section "[Custom Patterns via Palettes](https://github.com/RRethy/vim-hexokinase/blob/master/doc/hexokinase.txt#L175)".

I created the list of values using the script at [mardlo's Gist](https://gist.github.com/marslo/8e4e1988de79957deb12f0eecec588ec#file-color-utils-sh-L101), but the 16 first colors are dependent on your terminal confirguration, those could be set from the terminal settings or system wide like for URxvt which uses Xressources.

So you may have to adjust the colors 0 to 15 in those 2 files.

For the Foreground file "lpcolorsFg2hexTable.json" it's easy to do manually, but for the background file "lpcolorsBg2hexTable.json" I had to create thousands of combinations because of the limitations of the plugin, so you can use someting like sed.

Example:

``` bash
# write an array of your terminal colors from 0 to 15
terminalColors=("#4d4d4d" "#FF525C" "#C4FF6E" "#FFB937" "#558BFF" "#CE84FF" "#51CDFF" "#BCCFCF" "#546E7A" "#F07178" "#C3E88D" "#FFCB6B" "#82AAFF" "#C792
EA" "#89DDFF" "#FFFFFF")
declare -p terminalColors
index=0

# for each color index number, change the value in the file
for color in "${terminalColors[@]}"
do
    sed -i -E "s/(\s${index}\":\s\")#[A-Za-z0-9]{6}/\1${color}/g" lpcolorsBg2hexTable.json.bak
    ((index=index+1))
done
```

## Installation

1. Install Golang.
2. Install Vim or Neovim.
3. Install vim-hexokinase:

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

4. Copy the JSON files:

Example for VIM8+:

``` bash
mkdir ~/.vimrc/assets/
cp lpcolorsBg2hexTable.json ~/.vimrc/assets/
cp lpcolorsFg2hexTable.json ~/.vimrc/assets/
```

5. Configure Vim or Neovim:

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
  \  expand($HOME).'/.vimrc/assets/lpcolorsBg2hexTable.json',
  \  expand($HOME).'/.vimrc/assets/lpcolorsFg2hexTable.json'
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

