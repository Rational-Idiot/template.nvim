local M = {}

local config = {
	template_dir = vim.fn.stdpath("config") .. "/lua/templates",
}

function M.setup(opts)
	config = vim.tbl_deep_extend("force", config, opts or {})
end

local function find_templates(ext)
	local matched = {}
	local handle = vim.loop.fs_scandir(config.template_dir)
	if not handle then
		return nil
	end

	while true do
		local name, typ = vim.loop.fs_scandir_next(handle)
		if not name then
			break
		end
		if typ == "file" and name:sub(-#ext - 1) == "." .. ext then
			table.insert(matched, config.template_dir .. "/" .. name)
		end
	end

	return matched
end

function M.insert_template()
	local buf_name = vim.api.nvim_buf_get_name(0)
	local ext = vim.fn.fnamemodify(buf_name, ":e")
	if ext == "" then
		print("No file extension found.")
		return
	end

	local templates = find_templates(ext)

	if not templates or vim.tbl_isempty(templates) then
		print("No matching templates found for extension: " .. ext)
		return
	end

	vim.ui.select(templates, {
		prompt = "Select the template file",
	}, function(choice)
		if not choice then
			print("No template selected.")
			return
		end

		if vim.fn.filereadable(choice) == 0 then
			print("Selected template is unreadable.")
			return
		end

		local lines = vim.fn.readfile(choice)
		if not lines or vim.tbl_isempty(lines) then
			print("Template is empty or unreadable.")
			return
		end

		vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

		for i, line in ipairs(lines) do
			local s = string.find(line, "__cursor__")
			if s then
				local indent = line:match("^%s*") or ""
				vim.api.nvim_buf_set_lines(0, i - 1, i, false, { indent })
				vim.api.nvim_win_set_cursor(0, { i, #indent })
				vim.cmd("startinsert")
				return
			end
		end

		print("No 'cursor' marker found in template.")
	end)
end

vim.api.nvim_create_user_command("Template", function()
	require("template").insert_template()
end, {})

return M
