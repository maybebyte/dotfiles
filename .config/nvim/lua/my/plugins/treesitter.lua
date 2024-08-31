-- luacheck: globals vim

return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		"nvim-treesitter/nvim-treesitter-context",
	},
	lazy = true,
	event = { "BufReadPost", "BufNewFile", "FileType" },
	build = function()
		vim.cmd("TSUpdate")
	end,
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"css",
			"diff",
			"gitcommit",
			"go",
			"html",
			"lua",
			"make",
			"python",
			"query",
			"vim",
			"vimdoc",
		},
		sync_install = false,
		auto_install = false,

		highlight = {
			enable = true,

			-- Setting this to true will run `:h syntax` and tree-sitter at
			-- the same time.
			--
			-- Set this to `true` if you depend on 'syntax' being enabled
			-- (like for indentation).
			--
			-- Using this option may slow down your editor, and you may see
			-- some duplicate highlights.
			--
			-- Instead of true it can also be a list of languages.
			additional_vim_regex_highlighting = false,
		},
		indent = { enable = true },
		textobjects = {
			select = {
				enable = true,
				lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]a"] = "@parameter.inner",
					["]m"] = "@function.outer",
					["]]"] = "@class.outer",
				},
				goto_next_end = {
					["]A"] = "@parameter.inner",
					["]M"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[a"] = "@parameter.inner",
					["[m"] = "@function.outer",
					["[["] = "@class.outer",
				},
				goto_previous_end = {
					["[A"] = "@parameter.inner",
					["[M"] = "@function.outer",
					["[]"] = "@class.outer",
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>lp"] = "@parameter.inner",
					["<leader>jf"] = "@function.outer",
					["<leader>jc"] = "@class.outer",
				},
				swap_previous = {
					["<leader>hp"] = "@parameter.inner",
					["<leader>kf"] = "@function.outer",
					["<leader>kc"] = "@class.outer",
				},
			},
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
