return { "nvim-tree/nvim-tree.lua", opts = {},
	init = function()
		local api = require("nvim-tree.api")
		vim.keymap.set("n", "<Leader>e", api.tree.toggle, {desc = "nvim-tree: Toggle Tree"})
	end,
}
