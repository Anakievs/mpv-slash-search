local search= require('search')

function slash_search()
	search:init()
	search:enter_input_mode()
	mp.osd_message('/', 600)
end

mp.add_forced_key_binding('/', 'slash_search', slash_search)
