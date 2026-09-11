vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(ev)
		local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = ev.buf,
			callback = function()
				-- Sync formatting blocks the editor briefly to guarantee
				-- the file formats completely before it flushes to disk.
				vim.lsp.buf.format({ async = false, id = ev.data.client_id })
			end,
		})

		if client.name == "gdscript" or client.name == "cssls" then
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
			ensure_installed = {
				"lua_ls",
				"html",
				"prettier",
				"gdscript-formatter",
				"gdtoolkit",
			}
		})

		vim.opt.completeopt = { "menu", "menuone", "noselect", "fuzzy" }

		--Enable (broadcasting) snippet capability for completion
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		vim.lsp.config('cssls', {
			capabilities = capabilities,
		})

		vim.keymap.set('n', '<C-k>', vim.diagnostic.open_float, { desc = "View line error" })

		vim.keymap.set("i", "<C-j>", "<C-n>")
		vim.keymap.set("i", "<C-k>", "<C-p>")
	end,
}
