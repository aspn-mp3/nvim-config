return ({
	settings = {
		Lua = {
			diagnostics = {
				-- Prevent the language server from warning you about the 'vim' global
				globals = { 'vim' },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
})
