-- luacheck: globals vim

return {
	"stevearc/conform.nvim",
	lazy = true,
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

		-- Add format keymap
		vim.keymap.set({ "n", "v" }, "<leader>frm", function()
			require("conform").format({
				lsp_fallback = true,
				async = false,
			})
		end, { desc = "Format file or range" })
	end,
}
