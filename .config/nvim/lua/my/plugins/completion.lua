-- Formatting configuration
local function get_formatting_config()
	local lspkind = require("lspkind")
	return {
		expandable_indicator = true,
		fields = { "abbr", "kind" },
		format = lspkind.cmp_format({
			mode = "symbol_text",
			maxwidth = 50,
			ellipsis_char = "…",
			show_labelDetails = true,
			symbol_map = { Copilot = "" },
		}),
	}
end

-- Setup command-line completions
local function setup_cmdline_completions(cmp)
	-- Command line completion for search
	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	-- Command line completion for commands
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
			{ name = "cmdline" },
		}),
	})
end

-- Autocompletion setup
return {
	"hrsh7th/nvim-cmp",
	lazy = true,
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		-- Standard completion sources
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-cmdline",
		"onsails/lspkind.nvim",

		-- Copilot integration
		{
			"zbirenbaum/copilot-cmp",
			dependencies = { "zbirenbaum/copilot.lua" },
			opts = {},
		},

		-- Snippet support
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			dependencies = {
				"saadparwaiz1/cmp_luasnip",
				"rafamadriz/friendly-snippets",
			},
		},

		-- Neovim Lua development
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
		local utils = require("my.completion_utils")

		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			formatting = get_formatting_config(),
			sources = utils.get_completion_sources(),
			mapping = utils.get_keymappings(cmp, luasnip),
			enabled = function()
				local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
				if buftype == "prompt" then
					local cmp_dap = package.loaded["cmp_dap"]
					return cmp_dap and cmp_dap.is_dap_buffer()
				end
				return true
			end,
		})

		setup_cmdline_completions(cmp)
	end,
}
