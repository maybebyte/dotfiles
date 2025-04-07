-- luacheck: globals vim

-- Server-specific configuration functions
local server_configs = {
	pyright = function(capabilities)
		return {
			capabilities = capabilities,
			settings = {
				pyright = {
					disableLanguageServices = true,
				},
			},
		}
	end,
	-- Add more server-specific configs as needed
}

local function setup_keybinds_on_attach(bufnr)
	vim.keymap.set(
		"n",
		"gd",
		vim.lsp.buf.definition,
		{ buffer = bufnr, desc = "Go to definition of symbol under cursor" }
	)

	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Show documentation for symbol under cursor" })

	vim.keymap.set(
		"n",
		"<leader>vws",
		vim.lsp.buf.workspace_symbol,
		{ buffer = bufnr, desc = "Search for symbol across workspace" }
	)

	vim.keymap.set(
		"n",
		"<leader>vca",
		vim.lsp.buf.code_action,
		{ buffer = bufnr, desc = "Show code actions for current context" }
	)

	vim.keymap.set(
		"n",
		"<leader>vrr",
		vim.lsp.buf.references,
		{ buffer = bufnr, desc = "Find all references to symbol under cursor" }
	)

	vim.keymap.set(
		"n",
		"<leader>vrn",
		vim.lsp.buf.rename,
		{ buffer = bufnr, desc = "Rename symbol under cursor across files" }
	)

	vim.keymap.set(
		"i",
		"<C-h>",
		vim.lsp.buf.signature_help,
		{ buffer = bufnr, desc = "Show signature help (parameter info)" }
	)

	vim.keymap.set(
		"n",
		"<leader>vf",
		vim.lsp.buf.format,
		{ buffer = bufnr, desc = "Format current buffer with LSP formatter" }
	)
end

local function setup_lsp_diagnostics()
	-- Configure diagnostic signs
	local signs = {
		Error = "E",
		Warn = "W",
		Hint = "H",
		Info = "I",
	}

	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	-- Global diagnostic keymaps
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
	vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
end

local function setup_lsp_servers()
	-- Configure Mason for LSP server installations
	require("mason").setup()
	require("mason-lspconfig").setup()

	-- Get capabilities from cmp_nvim_lsp
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	-- Setup LSP servers with mason-lspconfig
	require("mason-lspconfig").setup_handlers({
		-- Default handler for servers without specific config
		function(server_name)
			local server_config = server_configs[server_name]
			if server_config then
				require("lspconfig")[server_name].setup(server_config(capabilities))
			else
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
				})
			end
		end,
	})
end

return {
	"neovim/nvim-lspconfig",
	lazy = true,
	cmd = { "LspInfo", "LspInstall", "LspStart" },
	event = { "BufReadPost", "BufNewFile", "FileType" },
	dependencies = {
		-- Mason for LSP server management
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",

		-- Completion capabilities for nvim-cmp
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		setup_lsp_diagnostics()

		-- Create autocommand for LSP attachment
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				setup_keybinds_on_attach(ev.buf)
			end,
		})
		setup_lsp_servers()
	end,
}
