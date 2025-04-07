-- luacheck: globals vim

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

		-- Global mappings
		-- See `:help vim.diagnostic.*` for documentation on these functions
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
		vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { desc = "Open diagnostic float" })

		-- Use LspAttach autocommand to only map the following keys
		-- after the language server attaches to the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf }

				vim.keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
				end, opts)

				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover()
				end, opts)

				vim.keymap.set("n", "<leader>vws", function()
					vim.lsp.buf.workspace_symbol()
				end, opts)

				vim.keymap.set("n", "<leader>vca", function()
					vim.lsp.buf.code_action()
				end, opts)

				vim.keymap.set("n", "<leader>vrr", function()
					vim.lsp.buf.references()
				end, opts)

				vim.keymap.set("n", "<leader>vrn", function()
					vim.lsp.buf.rename()
				end, opts)

				vim.keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)

				vim.keymap.set("n", "<leader>vf", function()
					vim.lsp.buf.format()
				end, opts)
			end,
		})

		-- Configure Mason for LSP server installations
		require("mason").setup()

		-- Configure mason-lspconfig
		require("mason-lspconfig").setup({
			-- You can specify servers to be installed here (optional)
			-- ensure_installed = {
			-- 	"bashls",
			-- 	"clangd",
			-- 	"cssls",
			-- 	"gopls",
			-- 	"html",
			-- 	"perlnavigator",
			-- 	"pylsp",
			-- 	"pyright",
			-- 	"stylelint_lsp",
			-- },
		})

		-- Get capabilities from cmp_nvim_lsp
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Setup LSP servers with mason-lspconfig
		require("mason-lspconfig").setup_handlers({
			-- Default handler
			function(server_name)
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
				})
			end,

			-- Custom handler for specific servers
			["pyright"] = function()
				require("lspconfig").pyright.setup({
					capabilities = capabilities,
					settings = {
						pyright = {
							disableLanguageServices = true,
						},
					},
				})
			end,
			-- Add other server-specific configurations here
		})
	end,
}
