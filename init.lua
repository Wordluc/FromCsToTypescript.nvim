local uv = require('luv')

local function create_server(host, port, on_connection)
	local server = uv.new_udp()
	server:bind(host, port)
	print("Listening on " .. host .. ":" .. port)
	server:recv_start(function(err, data, from)
		assert(not err, err)
		if data then
			print(data)
		end
	end)
end
create_server("0.0.0.0", 300)

uv.run()

