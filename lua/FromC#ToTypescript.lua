local uv = require('luv')
local M = {}
local function manage_server(str, host, port)
	local client = uv.new_udp()
	client:send(str, host, port, function(err)
		if err then
			print("Error sending data: ", err)
			return
		end
		client:recv_start(function(err, data, addr, flags)
			if err then
				print("Error receiving data: ", err)
				return
			end
			if data then
				local prova = vim.json.decode(data)
				if prova.Status.Code == 200 then
					vim.schedule(function()
						print("Converted")
						vim.fn.setreg("", prova.Body)
					end)
				else
					print("Error:" .. prova.Status.Msg)
				end
			end
		end)
	end)
end

M.create_server = function(port, str)
	uv.run("nowait") -- This is necessary to start the event loop
	local handle, pid = uv.spawn(
		"~\\..\\src\\GoFromCsToTypescript\\GoFromCsToTypescript.exe "
		, { args = { port } }, function() end
	)
	if handle==nil then
    print("Error starting server:"..pid)
	end
	if pid then
		manage_server(str, "127.0.0.1", port)
	else
		print("Error starting server creation job.")
	end
	uv.stop()
end
return M

