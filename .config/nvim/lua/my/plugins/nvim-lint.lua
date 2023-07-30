-- luacheck: globals vim

return {
	'mfussenegger/nvim-lint',
	config = function()
		require('lint').linters_by_ft = {
			lua = { 'luacheck', },
			css = { 'stylelint', },
			html = { 'erb_lint', },
			-- sh = { 'shellcheck', }, -- Illegal instruction (core dumped) on OpenBSD-current
			markdown = { 'proselint', },
			text = { 'proselint', },
		}

		-- NOTE: by default, erb_lint cmd and args are expecting a
		-- Gemfile (bundle exec), but mason.nvim doesn't create one
		--
		-- Unsure whether to mention this to
		-- https://github.com/williamboman/mason.nvim/issues
		require('lint').linters.erb_lint.cmd = 'erblint'
		require('lint').linters.erb_lint.args = { '--format', 'compact' }

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end
}
