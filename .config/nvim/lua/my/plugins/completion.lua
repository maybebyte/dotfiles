-- Autocompletion setup
return {
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
			opts = {},
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
					symbol_map = { Copilot = "" },
				}),
			},
			sources = {
				-- Group 1: AI and LSP (highest priority)
				{ name = "copilot", priority = 1000 },
				{ name = "nvim_lsp", priority = 900 },

				-- Group 2: Snippets
				{ name = "luasnip", priority = 750 },

				-- Group 3: Neovim-specific
				{ name = "nvim_lua", priority = 600 },

				-- Group 4: Filesystem and buffer
				{ name = "path", priority = 500 },
				{ name = "buffer", priority = 400, keyword_length = 3 },

				-- Keep lazydev in its own group
				{ name = "lazydev", group_index = 0 }, -- set group index to 0 to skip loading LuaLS completions
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
}
