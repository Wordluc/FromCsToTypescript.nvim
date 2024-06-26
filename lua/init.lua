local uv = require('luv')

local M = {}
M.create_server = function (host, port)
	local server = uv.new_udp()
	server:bind(host, port)
	print("Listening on " .. host .. ":" .. port)
	server:recv_start(function(err, data, from)
		assert(not err, err)
		if data then
			print(data)
		end
	end)
	uv.run()
end

return M
