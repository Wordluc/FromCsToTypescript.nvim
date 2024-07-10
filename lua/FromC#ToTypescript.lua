local uv = require('luv')
local M = {}

M.convertDto = function(reg)
	if not reg then
		reg = ""
	end
	uv.run("nowait") -- This is necessary to start the event loop
	local stdin = uv.new_pipe()
	local stdout = uv.new_pipe()
	local stderr = uv.new_pipe()
	local script_path = debug.getinfo(1, "S").source:sub(2)
	local executable_path = script_path:match(".*/") .. "../src/GoFromCsToTypescript/GoFromCsToTypescript.exe"
	local handle, pid = uv.spawn(
		executable_path
		, { stdio = { stdin, stdout, stderr } }, function() end
	)
	if not pid or not handle then
		print("Error starting server")
		return
	end
	stdin:write(vim.fn.getreg(reg))
	stdout:read_start(function(e, data)
		assert(not e, e)
		if data then
			vim.schedule(function()
				print("Converted")
				vim.fn.setreg(reg, data)
			end)
		end
	end)
	stderr:read_start(function(e, data)
		assert(not e, e)
		if data then
			print(data)
		end
	end)
end
return M

