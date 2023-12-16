local search= require('search')

function slash_search()
	search:init()
	search:enter_input_mode(on_search_input_done)
	search.input_string= ""
	mp.osd_message("/", 600)
end

function on_search_input_done()
	search.result= search:filtered_playlist(search.input_string)
	if search.result[0] then
		mp.commandv("playlist-play-index", search.result[search.resultIndex][1])
	end
	mp.osd_message("")
end

mp.add_forced_key_binding('/', 'slash_search', slash_search)
