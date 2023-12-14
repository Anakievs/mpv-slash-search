# mpv-slash-search

Simple and lightweight script that allows you to search for a file in the playlist and jump to the first match.
It will display the matching file in a new line.

## Usage

Press "/" type a keyword than press Enter.

## Keybindings

| Key | Action |
| --- | ------ |
| <kbd>/</kbd> | Enter search mode. |
| <kbd>Enter</kbd> | Play the first match found. |
| <kbd>ESC</kbd> | Cancel the search. |

## Screenshot
![Screenshot](https://github.com/Anakievs/mpv-slash-search/Screenshot.png)

I've made this script for myself but it can be useful for someone else. The search is case-insensitive, "." and ".*" are supported.
The script is modification of drogers141's [mpv-playlist-navigator](https://github.com/drogers141/mpv-playlist-navigator).
Keep in mind that this is my first time using Lua.

## Installation

Copy "slashSearch.lua" to "~/.config/mpv/scripts/" and "search.lua" to "/usr/share/lua/5.1/". Tested on Arch Linux.
