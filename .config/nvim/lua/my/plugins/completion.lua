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
	-- Core nvim-cmp (loads on both InsertEnter and CmdlineEnter)
	{
		"hrsh7th/nvim-cmp",
		lazy = true,
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			-- Core dependencies used by both insert and cmdline modes
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-cmdline",
			"onsails/lspkind.nvim",

			-- Neovim Lua development
			{
				"folke/lazydev.nvim",
				lazy = true,
				ft = "lua",
				opts = {
					library = {
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
			local utils = require("my.completion_utils")
			local luasnip_ok, luasnip = pcall(require, "luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						if luasnip_ok then
							luasnip.lsp_expand(args.body)
						elseif vim.fn.has("nvim-0.10") == 1 then
							vim.snippet.expand(args.body)
						else
							vim.notify("[cmp] Snippet expansion requires LuaSnip or Neovim 0.10+", vim.log.levels.WARN)
						end
					end,
				},
				formatting = get_formatting_config(),
				sources = utils.get_completion_sources(),
				mapping = luasnip_ok and utils.get_keymappings(cmp, luasnip) or utils.get_keymappings_no_snippets(cmp),
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
	},

	-- Snippet support (InsertEnter only - not needed for cmdline)
	{
		"saadparwaiz1/cmp_luasnip",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/nvim-cmp",
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				dependencies = { "rafamadriz/friendly-snippets" },
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
		},
		config = function()
			require("cmp_luasnip")
			local ok, utils = pcall(require, "my.completion_utils")
			if ok then
				utils.reconfigure_cmp()
			else
				vim.notify("[cmp] Failed to load completion_utils: " .. tostring(utils), vim.log.levels.WARN)
			end
		end,
	},
}
