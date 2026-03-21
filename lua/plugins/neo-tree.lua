local function notify_path_copied(path_kind, path)
	vim.fn.setreg("+", path)
	vim.notify(("Copied %s path: %s"):format(path_kind, path), vim.log.levels.INFO, { title = "Neo-tree" })
end

local function get_node_path(state)
	local node = state.tree:get_node()
	if not node then
		vim.notify("No Neo-tree node selected", vim.log.levels.ERROR, { title = "Neo-tree" })
		return nil
	end

	local path = node.get_id and node:get_id() or node.path
	if not path or path == "" then
		vim.notify("Selected Neo-tree node has no path", vim.log.levels.ERROR, { title = "Neo-tree" })
		return nil
	end

	return vim.fs.normalize(path)
end

local function get_git_root(path)
	local directory = vim.fn.isdirectory(path) == 1 and path or vim.fn.fnamemodify(path, ":h")
	local result = vim.system({ "git", "-C", directory, "rev-parse", "--show-toplevel" }, { text = true }):wait()

	if result.code ~= 0 then
		return nil
	end

	return vim.trim(result.stdout)
end

local function to_git_relative_path(path)
	local git_root = get_git_root(path)
	if not git_root or git_root == "" then
		return path
	end

	if path == git_root then
		return "."
	end

	local prefix = git_root .. "/"
	if vim.startswith(path, prefix) then
		return "." .. path:sub(#git_root + 1)
	end

	return path
end

local function copy_selected_node_path(state, transform, path_kind)
    local path = get_node_path(state)
    if not path then
        return
    end

    notify_path_copied(path_kind, transform(path))
end

local function wait_for_next_key()
end

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	config = function()
		require("neo-tree").setup({
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,
				},
                window = {
                    mappings = {
                        ["y"] = {
                            wait_for_next_key,
                            desc = "Await yy path copy",
                            nowait = false,
                        },
                        ["yy"] = {
                            function(state)
                                copy_selected_node_path(state, to_git_relative_path, "relative")
                            end,
                            desc = "Copy path relative to git root",
                            nowait = false,
                        },
                        ["Y"] = {
                            wait_for_next_key,
                            desc = "Await YY path copy",
                            nowait = false,
                        },
                        ["YY"] = {
                            function(state)
                                copy_selected_node_path(state, function(path)
                                    return path
                                end, "absolute")
							end,
							desc = "Copy absolute path",
						},
					},
				},
			},
		})
		vim.keymap.set(
			"n",
			"<leader>/",
			":Neotree toggle current reveal_force_cwd<cr>",
			{ desc = "Neotree Toggle CWD" }
		)
	end,
}
