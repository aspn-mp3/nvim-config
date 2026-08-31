return ({ "https://codeberg.org/andyg/leap.nvim", opts = {},
	config = function()
		vim.keymap.set("n", "S", "<Plug>(leap)")
	end
})
