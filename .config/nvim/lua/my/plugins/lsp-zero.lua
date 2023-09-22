-- luacheck: globals vim

return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v3.x",
		lazy = true,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = true,
	},
	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		lazy = true,
		event = "VeryLazy",
		dependencies = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-cmdline" },
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				dependencies = {
					{ "saadparwaiz1/cmp_luasnip" },
					{ "rafamadriz/friendly-snippets" },
				},
			},
		},
		config = function()
			local lsp = require("lsp-zero")
			lsp.extend_cmp()

			local cmp = require("cmp")
			local cmp_action = lsp.cmp_action()
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			local cmp_mappings = lsp.defaults.cmp_mappings({
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			})

			-- Needs to be separate from above, otherwise <Tab> completes.
			cmp_mappings["<Tab>"] = nil
			cmp_mappings["<S-Tab>"] = nil

			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				sources = {
					{ name = "buffer" },
					{ name = "luasnip" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "path" },
				},
				mapping = {
					["<C-f>"] = cmp_action.luasnip_jump_forward(),
					["<C-b>"] = cmp_action.luasnip_jump_backward(),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
				},
			})
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
					{ name = "cmdline" },
				}),
			})
		end,
	},
	-- LSP Support
	{
		"neovim/nvim-lspconfig",
		lazy = true,
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local lsp = require("lsp-zero")
			lsp.extend_lspconfig()

			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"cssls",
					"gopls",
					"perlnavigator",
					"html",
					"pylsp",
					"pyright",
					"stylelint_lsp",
				},
				handlers = {
					lsp.default_setup,
					pyright = function()
						require("lspconfig").pyright.setup({
							settings = {
								pyright = {
									disableLanguageServices = true,
								},
							},
						})
					end,
				},
			})

			lsp.set_sign_icons = {
				error = "E",
				warn = "W",
				hint = "H",
				info = "I",
			}

			lsp.on_attach(function(_, bufnr)
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
	},
}
