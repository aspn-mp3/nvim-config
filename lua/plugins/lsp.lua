vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Buffer-local autocommand for formatting on save
		vim.api.nvim_create_autocmd('BufWritePre', {
			buffer = ev.buf,
			callback = function()
				vim.lsp.buf.format({ async = false })
			end,
		})
	end,
})

return {
	"neovim/nvim-lspconfig",
	opts = {},
	dependencies = {
		"williamboman/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim"
	},

	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup()
		require("mason-tool-installer").setup({
			ensure_installed = { "lua_ls" }
		})

		local lsps = {
			"lua_ls",
			"godot"
		}
	end,
}
