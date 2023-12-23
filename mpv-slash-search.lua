local utils= require('mp.utils')

local search= {
	pos= 0,
	len= 0,
	resultIndex= 0,
	files= {},
	result= {}
}

AVAILABLE_INPUT_CHARS= 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.*%?+()'
input_string= ''

function enter_input_mode()
	add_search_keybindings()
	show_input()
end

function show_input()
	input_line= '/'.. input_string
	result= filtered_playlist(input_string)
	if result[resultIndex] then
		local l_path, t= utils.split_path(mp.get_property('playlist/'.. result[resultIndex][1].. '/filename'))
		input_line= input_line.. '\n'.. t
	end
	mp.osd_message(input_line, 600)
end

function handle_search_enter(playNext)
	remove_search_keybindings()
	result= filtered_playlist(input_string)
	if result[resultIndex] then
		if result[resultIndex][1]~= pos then
			mp.commandv('playlist-move', result[resultIndex][1], pos+ 1)
			if playNext then
				mp.commandv('playlist-next')
			end
		end
	end
	mp.osd_message('')
end

function handle_search_escape()
	remove_search_keybindings()
	mp.osd_message('')
	input_string= ''
end

function handle_backspace()
	if input_string== '' then
		return
	end
	resultIndex= 0
	input_string= string.sub(input_string, 1, -2)
	show_input()
end

function handle_input(char)
	resultIndex= 0
	input_string= input_string.. char
	show_input()
end

function resultDec()
	if resultIndex> 0 then
		resultIndex= resultIndex- 1
	end
	show_input()
end

function resultInc()
	if resultIndex< #result then
		resultIndex= resultIndex+ 1
	end
	show_input()
end

local SEARCH_BINDINGS= {}

function add_search_keybindings()
	local bindings= {
		{'BS', handle_backspace},
		{'Ctrl+h', handle_backspace},
		{'ENTER', function() handle_search_enter(true) end},
		{'Ctrl+j', function() handle_search_enter(true) end},
		{'Ctrl+n', handle_search_enter},
		{'Ctrl+i', resultDec},
		{'Ctrl+o', resultInc},
		{'ESC', handle_search_escape},
		{'TAB', function() handle_input('.*') end},
		{'SPACE', function() handle_input(' ') end}
	}
	for ch in AVAILABLE_INPUT_CHARS:gmatch'.' do
		bindings[#bindings+ 1]= {ch, function() handle_input(ch) end}
	end
	for i, binding in ipairs(bindings) do
		local key= binding[1]
		local func= binding[2]
		local name= '__search_binding_'.. i
		SEARCH_BINDINGS[#SEARCH_BINDINGS+ 1]= name
		mp.add_forced_key_binding(key, name, func, 'repeatable')
	end
end

function remove_search_keybindings()
	for i, key_name in ipairs(SEARCH_BINDINGS) do
		mp.remove_key_binding(key_name)
	end
end

function init()
	pos= mp.get_property_number('playlist-pos', 0)
	len= mp.get_property_number('playlist-count', 0)
	input_string= ''
	files= get_playlist()
end

function get_playlist()
	local pl= {}
	for i=0, len-1, 1
	do
		local l_path, l_file= utils.split_path(mp.get_property('playlist/'.. i.. '/filename'))
		pl[i]= l_file
	end
	return pl
end

function case_insensitive_pattern(pattern)
	local p= pattern:gsub('(%%?)(.)', function(percent, letter)
		if percent~= '' or not letter:match('%a') then
			return percent.. letter
		else
			return string.format('[%s%s]', letter:lower(), letter:upper())
		end
	end)
	return p
end

function filtered_playlist(search_term)
	case_insensitive_term= case_insensitive_pattern(search_term)
	filtered= {}
	f_index= 0
	for i=0, #files do
		local filename= files[i]
		m= string.match(filename, case_insensitive_term)
		if m and#m> 0 then
			local row= {i, filename}
			filtered[f_index]= row
			f_index= f_index+ 1
		end
	end
	return filtered
end

function slash_search()
	init()
	enter_input_mode()
	mp.osd_message('/', 600)
end

mp.add_forced_key_binding('/', 'slash_search', slash_search)
