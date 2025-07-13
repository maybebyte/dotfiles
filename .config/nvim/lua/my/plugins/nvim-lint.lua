-- luacheck: globals vim

return {
	"mfussenegger/nvim-lint",
	lazy = true,
	ft = {
		"go",
		"lua",
		"html",
		"markdown",
		"text",
		"python",
	},
	config = function()
		require("lint").linters_by_ft = {
			go = { "revive" },
			lua = { "luacheck", "selene" },
			html = { "erb_lint" },
			markdown = { "markdownlint" },
			python = { "mypy", "pylint", "ruff" },
		}

		-- NOTE: by default, erb_lint cmd and args are expecting a
		-- Gemfile (bundle exec), but mason.nvim doesn't create one
		--
		-- Unsure whether to mention this to
		-- https://github.com/williamboman/mason.nvim/issues
		require("lint").linters.erb_lint.cmd = "erblint"
		require("lint").linters.erb_lint.args = { "--format", "compact" }

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})

		vim.api.nvim_create_autocmd({ "FileType", "InsertLeave" }, {
			pattern = {
				"lua",
			},
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
