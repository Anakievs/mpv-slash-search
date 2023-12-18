# mpv-slash-search

Simple and lightweight script that allows you to search for a file in the playlist and jump to the first match.
As you type the result will appear on the next line.

## Usage

Press "/" type a keyword than press Enter.

## Keybindings

| Key | Action |
| --- | ------ |
| <kbd>/</kbd> | Enter search mode. <br /> Reset the search. |
| <kbd>Enter</kbd> or <kbd>Ctrl</kbd>+<kbd>j</kbd> | Play the first match found. |
| <kbd>Backspace</kbd> or <kbd>Ctrl</kbd>+<kbd>h</kbd> | Delete a character. |
| <kbd>Ctrl</kbd> + <kbd>i</kbd> or <kbd>Ctrl</kbd> + <kbd>o</kbd> | Browse though the results. |
| <kbd>TAB</kbd> | Insert ".*" |
| <kbd>ESC</kbd> | Cancel the search. |

## Screenshot
![Screenshot](Screenshot.png)

I've made this script for myself but it can be useful for someone else. The search is case-insensitive, "." and ".*" are supported.
The script is modification of [drogers141/mpv-playlist-navigator](https://github.com/drogers141/mpv-playlist-navigator).
Keep in mind that this is my first time using Lua.

## Installation

Copy "main.lua" and "search.lua" to "~/.config/mpv/scripts/mpv-slash-search/".
