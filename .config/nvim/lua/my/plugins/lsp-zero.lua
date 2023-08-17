-- luacheck: globals vim

-- TODO: Adjust for future changes/deprecation notice and breaking
-- changes
-- https://github.com/VonHeikemen/lsp-zero.nvim
return {
	"VonHeikemen/lsp-zero.nvim",
	branch = "v2.x",
	dependencies = {
		-- LSP Support
		{ "neovim/nvim-lspconfig" }, -- Required
		{ "williamboman/mason.nvim" }, -- Optional
		{
			"williamboman/mason-lspconfig.nvim", -- Optional
			dependencies = {
				{ "williamboman/mason.nvim" },
			},
			init = function()
				--require('mason').setup()
				require("mason").setup({
					log_level = vim.log.levels.DEBUG,
				})
				require("mason-lspconfig").setup({
					ensure_installed = {
						"bashls",
						"cssls",
						"perlnavigator",
						"html",
						"pylsp",
						"stylelint_lsp",
					},
				})
			end,
		},

		-- Autocompletion
		{ "hrsh7th/nvim-cmp" }, -- Required
		{ "hrsh7th/cmp-nvim-lsp" }, -- Required
		{ "L3MON4D3/LuaSnip" }, -- Required
	},
	init = function()
		local lsp = require("lsp-zero")

		lsp.preset({})

		-- NOTE: lua_ls doesn't work on OpenBSD yet ('Unsupported platform').
		-- Fix Undefined global 'vim'
		--lsp.configure('lua-language-server', {
		--settings = {
		--Lua = {
		--diagnostics = {
		--globals = { 'vim' }
		--}
		--}
		--}
		--})

		local cmp = require("cmp")
		local cmp_select = { behavior = cmp.SelectBehavior.Select }
		local cmp_mappings = lsp.defaults.cmp_mappings({
			["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
			["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
			["<C-y>"] = cmp.mapping.confirm({ select = true }),
			["<C-Space>"] = cmp.mapping.complete(),
		})

		cmp_mappings["<Tab>"] = nil
		cmp_mappings["<S-Tab>"] = nil

		lsp.setup_nvim_cmp({
			mapping = cmp_mappings,
		})
		lsp.set_sign_icons = {
			error = "E",
			warn = "W",
			hint = "H",
			info = "I",
		}

		lsp.on_attach(function(client, bufnr)
			local opts = { buffer = bufnr, remap = false }

			vim.keymap.set("n", "gd", function()
				vim.lsp.buf.definition()
			end, opts)
			vim.keymap.set("n", "K", function()
				vim.lsp.buf.hover()
			end, opts)
			vim.keymap.set("n", "<leader>vws", function()
				vim.lsp.buf.workspace_symbol()
			end, opts)
			vim.keymap.set("n", "<leader>vd", function()
				vim.diagnostic.open_float()
			end, opts)
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.goto_next()
			end, opts)
			vim.keymap.set("n", "]d", function()
				vim.diagnostic.goto_prev()
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
		end)

		lsp.setup()
	end,
}
