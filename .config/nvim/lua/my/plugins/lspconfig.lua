-- luacheck: globals vim

return {
	-- LSP Configuration
	{
		"neovim/nvim-lspconfig",
		lazy = true,
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		event = { "BufReadPre", "BufNewFile", "FileType" },
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
	},

	-- Autocompletion setup
	{
		"hrsh7th/nvim-cmp",
		lazy = true,
		event = "VeryLazy",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-cmdline",
			"onsails/lspkind.nvim",
			{
				"zbirenbaum/copilot-cmp",
				dependencies = {
					"zbirenbaum/copilot.lua",
				},
				config = function()
					require("copilot_cmp").setup()
				end,
			},
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				dependencies = {
					"saadparwaiz1/cmp_luasnip",
					"rafamadriz/friendly-snippets",
				},
			},
			{
				"rcarriga/cmp-dap",
				dependencies = {
					"mfussenegger/nvim-dap",
					"rcarriga/nvim-dap-ui",
				},
			},
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			-- Load snippets
			require("luasnip.loaders.from_vscode").lazy_load()

			local lspkind = require("lspkind")
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				formatting = {
					expandable_indicator = true,
					fields = { "abbr", "kind" },
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "…",
						show_labelDetails = true,
						symbol_map = { Copilot = " " },
					}),
				},
				sources = {
					{ name = "buffer" },
					{ name = "luasnip" },
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					{ name = "path" },
					{ name = "lazydev", group_index = 0 }, -- set group index to 0 to skip loading LuaLS completions
					{ name = "copilot" },
				},
				mapping = {
					["<C-f>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-b>"] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),

					-- Completion selection
					["<C-y>"] = cmp.mapping.confirm(),
					["<C-n>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-p>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<C-Space>"] = cmp.mapping.complete(),
				},
				enabled = function()
					return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt"
						or require("cmp_dap").is_dap_buffer()
				end,
			})

			-- Setup for specific filetypes
			cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
				sources = {
					{ name = "dap" },
				},
			})

			-- Command line completion
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

	-- lazydev for Neovim Lua development
	{
		"folke/lazydev.nvim",
		lazy = true,
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
		dependencies = {
			{ "Bilal2453/luvit-meta", lazy = true },
		},
	},
}
