local utils= require('mp.utils')

local search= {
	pos= 0,
	len= 0,
	resultIndex= 0,
	files= {},
	result= {}
}

AVAILABLE_INPUT_CHARS= 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.*%?+()'
search.input_string= ''

function search:enter_input_mode()
	add_search_keybindings()
	self:show_input()
end

function search:show_input()
	input_line= '/'.. self.input_string
	result= search:filtered_playlist(search.input_string)
	if result[self.resultIndex] then
		local l_path, t= utils.split_path(mp.get_property('playlist/'.. result[self.resultIndex][1].. '/filename'))
		input_line= input_line.. '\n'.. t
	end
	mp.osd_message(input_line, 600)
end

function handle_search_enter(playNext)
	remove_search_keybindings()
	search.result= search:filtered_playlist(search.input_string)
	if search.result[search.resultIndex] then
		if search.result[search.resultIndex][1]~= search.pos then
			mp.commandv('playlist-move', result[search.resultIndex][1], search.pos+ 1)
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
	search.input_string= ''
end

function handle_backspace()
	if search.input_string== '' then
		return
	end
	search.input_string= string.sub(search.input_string, 1, -2)
	search:show_input()
end

function handle_input(char)
	search.resultIndex= 0
	search.input_string= search.input_string.. char
	search:show_input()
end

function resultDec()
	if search.resultIndex> 0 then
		search.resultIndex= search.resultIndex- 1
	end
	search:show_input()
end

function resultInc()
	if search.resultIndex< #result then
		search.resultIndex= search.resultIndex+ 1
	end
	search:show_input()
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

function search:init()
	self.pos= mp.get_property_number('playlist-pos', 0)
	self.len= mp.get_property_number('playlist-count', 0)
	self.input_string= ''
	self.files= self:get_playlist()
end

function search:get_playlist()
	local pl= {}
	for i=0, self.len-1, 1
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

function search:filtered_playlist(search_term)
	case_insensitive_term= case_insensitive_pattern(search_term)
	filtered= {}
	f_index= 0
	for i=0, #self.files do
		local filename= self.files[i]
		m= string.match(filename, case_insensitive_term)
		if m and#m> 0 then
			local row= {i, filename}
			filtered[f_index]= row
			f_index= f_index+ 1
		end
	end
	return filtered
end

return search
