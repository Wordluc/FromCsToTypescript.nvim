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
	local executable_path = "~\\..\\src\\GoFromCsToTypescript\\GoFromCsToTypescript.exe"

	local _, pid = uv.spawn(
		executable_path
		, { stdio = { stdin, stdout, stderr } }, function() end
	)
	if not pid then
		print("Error starting server")
		return
	end
	stdin:write(vim.fn.getreg(reg))
	stdout:read_start(function(_, data)
		if data then
			vim.schedule(function()
				print("Converted")
				vim.fn.setreg(reg)
			end)
		end
	end)
	stderr:read_start(function(_, data)
		if data then
			print(data)
		end
	end)
	uv.stop()
end
return M
