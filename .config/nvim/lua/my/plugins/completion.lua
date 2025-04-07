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

-- Completion sources configuration
local function get_completion_sources()
	return {
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
	}
end

-- Keymapping configuration
local function get_keymappings(cmp, luasnip)
	return {
		-- Snippet navigation
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

		-- Documentation scrolling
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),

		-- Completion selection
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

		["<C-y>"] = cmp.mapping.confirm(),
		["<C-Space>"] = cmp.mapping.complete(),
	}
end

-- Create the base configuration object
local function create_base_config(cmp, luasnip)
	return {
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		formatting = get_formatting_config(),
		sources = get_completion_sources(),
		mapping = get_keymappings(cmp, luasnip),
		enabled = function()
			return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt"
				or require("cmp_dap").is_dap_buffer()
		end,
	}
end

-- Setup filetype-specific configurations
local function setup_filetype_specific_configs(cmp)
	-- DAP-specific filetypes
	cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
		sources = {
			{ name = "dap" },
		},
	})
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
	event = "VeryLazy",
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

		-- Debug adapter protocol integration
		{
			"rcarriga/cmp-dap",
			dependencies = {
				"mfussenegger/nvim-dap",
				"rcarriga/nvim-dap-ui",
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

		require("luasnip.loaders.from_vscode").lazy_load()

		local base_config = create_base_config(cmp, luasnip)
		cmp.setup(base_config)

		setup_filetype_specific_configs(cmp)
		setup_cmdline_completions(cmp)
	end,
}
