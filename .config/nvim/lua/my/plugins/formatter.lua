-- luacheck: globals vim

return {
	"mhartington/formatter.nvim",
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
		"yaml",
	},
	config = function()
		require("formatter").setup({
			filetype = {
				c = {
					require("formatter.filetypes.c").clangformat,
				},
				css = {
					require("formatter.filetypes.css").prettier,
				},
				go = {
					require("formatter.filetypes.go").gofumpt,
				},
				html = {
					require("formatter.filetypes.html").prettier,
				},
				javascript = {
					require("formatter.filetypes.javascript").prettier,
				},
				json = {
					require("formatter.filetypes.json").prettier,
				},
				lua = {
					require("formatter.filetypes.lua").stylua,
				},
				markdown = {
					require("formatter.filetypes.markdown").prettier,
				},
				perl = {
					function()
						return {
							exe = "perltidy",
							args = {
								"--quiet",
							},
							stdin = true,
						}
					end,
				},
				python = {
					require("formatter.filetypes.python").black,
				},
				sh = {
					function()
						local shiftwidth = vim.opt.shiftwidth:get()
						local expandtab = vim.opt.expandtab:get()

						if not expandtab then
							shiftwidth = 0
						end

						return {
							exe = "shfmt",
							args = {
								"--simplify",
								"--case-indent",
								"--binary-next-line",
								"--space-redirects",
								"--indent",
								shiftwidth,
							},
							stdin = true,
						}
					end,
				},
				yaml = {
					require("formatter.filetypes.yaml").prettier,
				},
			},
		})
	end,
}
