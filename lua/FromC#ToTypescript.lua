local uv = require('luv')
local M = {}

local function manage_server(str, host, port)
	local client = uv.new_tcp()
	client:connect(host, port, function(err)
		if err then
			print("Error connecting to server:", err)
			return
		end
		client:write(str)
		client:read_start(function(err, data)
			if err then
				print("Error receiving data: ", err)
				return
			end
			if data then
				local response = vim.json.decode(data)
				if response.Status.Code == 200 then
					vim.schedule(function()
						print("Converted")
						vim.fn.setreg("", response.Body)
					end)
				else
					print("Error:", response.Status.Msg)
				end
				client:close()
			end
		end)
	end)
end

M.create_server = function(port, str)
	uv.run("nowait") -- This is necessary to start the event loop
	local script_path = debug.getinfo(1, "S").source:sub(2)
	local executable_path = script_path:match(".*/") .. "../src/GoFromCsToTypescript/GoFromCsToTypescript.exe"
	--local executable_path = "..\\..\\src\\GoFromCsToTypescript\\GoFromCsToTypescript.exe"
	local handle, pid = uv.spawn(
		executable_path
		, { args = { port } }, function() end
	)
	if handle == nil then
		print("Error starting server:" .. pid)
	end
	local timer = uv.new_timer()
	timer:start(100, 0, function()
		if pid then
			manage_server(str, "127.0.0.1", port)
		else
			print("Error starting server creation job.")
		end

		timer:close()
	end)

	uv.stop()
end
return M
