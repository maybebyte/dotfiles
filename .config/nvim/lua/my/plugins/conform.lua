-- luacheck: globals vim

return {
	"stevearc/conform.nvim",
	lazy = true,
	keys = {
		{
			"<leader>frm",
			function()
				require("conform").format({
					lsp_format = "fallback",
					async = false,
				})
			end,
			mode = { "n", "v" },
			desc = "Format file or range",
		},
	},
	ft = {
		"c",
		"css",
		"go",
		"html",
		"javascript",
		"json",
		"lua",
		"markdown",
		"perl",
		"python",
		"sh",
		"terraform",
		"terraform-vars",
		"tex",
		"xml",
		"yaml",
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				c = { "clang_format" },
				css = { "prettier" },
				go = { "gofumpt" },
				html = { "prettier" },
				javascript = { "prettier" },
				json = { "prettier" },
				lua = { "stylua" },
				markdown = { "prettier" },
				perl = { "perltidy" },
				python = { "black" },
				sh = { "shfmt" },
				terraform = { "terraform_fmt" },
				["terraform-vars"] = { "terraform_fmt" },
				tex = { "tex-fmt" },
				xml = { "xmlformatter" },
				yaml = { "prettier" },
			},
			-- Custom formatter configurations
			formatters = {
				shfmt = {
					prepend_args = function()
						local shiftwidth = vim.opt.shiftwidth:get()
						local expandtab = vim.opt.expandtab:get()
						local indent = expandtab and shiftwidth or 0

						return {
							"--simplify",
							"--case-indent",
							"--binary-next-line",
							"--space-redirects",
							"--indent",
							tostring(indent),
						}
					end,
				},
			},
		})
	end,
}
