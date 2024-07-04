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
						vim.fn.setreg("", prova.Body)
					end)
				else
					print("Error:" .. prova.Status.Msg)
				end
			end
		end)
	end)
end

M.create_server = function(host, port, str)
	local handle, server_process = uv.spawn(
		"C://Users//Usernexus//Desktop//PersonalProject//FromCsToTypeScript_PluginNvim//src//GoFromCsToTypescript//GoFromCsToTypescript.exe "
		, { args = { 90 } }, function() end
	)
	if server_process then
		manage_server(str, host, port)
	else
		print("Error starting server creation job.")
	end
end

uv.run() -- This is necessary to start the event loop
local str = vim.fn.getreg("")
M.create_server("127.0.0.1", 90, str)
return M
