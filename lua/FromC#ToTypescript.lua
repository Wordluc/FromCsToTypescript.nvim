local uv = require('luv')
local M = {}

M.create_server = function(host, port)
	local r=os.execute("C:\\Users\\frang\\Desktop\\Training\\FromCsToTypescript\\nvimPlugin\\src\\GoFromCsToTypescript\\GoFromCsToTypescript.exe " .. port)
	local client = uv.new_udp()
	client:send("public class prova{string ccc;}", host, port, function(err)
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
				print("holla")
				local prova = vim.json.decode(data)
				if prova.Status.Code == 200 then
					vim.schedule(function()
						vim.fn.setreg("", prova.Data)
					end)
				else
					print("Error")
				end
			end
		end)
	end)
end
uv.run() -- This is necessary to start the event loop

--M.create_server("127.0.0.1", 90)
return M
