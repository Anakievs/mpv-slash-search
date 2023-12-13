local search= require('search')

function slash_search()
	search:init()
	search:enter_input_mode(on_search_input_done)
end

function on_search_input_done()
	search.result= search:filtered_playlist(search.input_string)
	if search.result[0] then
		mp.commandv("playlist-play-index", search.result[0][1])
	end
	search.input_string= ""
	mp.osd_message("")
end

mp.add_forced_key_binding('/', 'slash_search', slash_search)
