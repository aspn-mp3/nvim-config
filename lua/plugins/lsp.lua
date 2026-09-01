vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

		if client.name == "gdscript" then
			-- Ensure the provider block exists
			if not client.server_capabilities.completionProvider then
				client.server_capabilities.completionProvider = {}
			end

			-- FIX: Inject ALL printable ASCII characters as triggers
			-- This forces an LSP query on every alphanumeric letter you type
			local all_chars = {}
			for i = 32, 126 do
				table.insert(all_chars, string.char(i))
			end
			client.server_capabilities.completionProvider.triggerCharacters = all_chars

			-- Enable autotrigger with the newly aggressive character array
			if vim.lsp.completion then
				vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
			end

			vim.diagnostic.config({ update_in_insert = true })
		else
			-- Standard behavior for normal LSPs (Lua, Python, etc.)
			if client:supports_method('textDocument/completion') then
				vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
			end
		end

		-- Format-on-save block remains unchanged...
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
			ensure_installed = { "lua_ls", "gdscript-formatter", "gdtoolkit" }
		})

		-- gdscript = function(_, opts)
		-- 	require("lspconfig")["gdscript"].setup({
		-- 		name = "godot",
		--
		-- 		-- Fill in your Godot Language Server parameters
		-- 		cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
		--
		-- 		-- Fill in where should Neovim listen to Godot LSP
		-- 		-- In this case, "/tmp/godot.pipe"
		-- 		on_init = function(client, init_result)
		-- 			vim.fn.serverstart("/tmp/godot.pipe")
		-- 		end,
		-- 	})
		-- 	return true
		-- end

		vim.opt.completeopt = { "menu", "menuone", "noselect", "fuzzy" }

		vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = "View line error" })

		vim.keymap.set("i", "<C-j>", "<C-n>")
		vim.keymap.set("i", "<C-k>", "<C-p>")
	end,
}
