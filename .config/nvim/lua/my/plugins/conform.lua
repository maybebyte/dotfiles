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
			-- Format-on-save gate. Explicit if/else (not Lua ternary) — `x and false or y`
			-- evaluates to y when x is true and middle value is false, which broke the
			-- autoformat-buffer test.
			format_on_save = function(bufnr)
				local effective = vim.b[bufnr].autoformat
				if effective == nil then
					effective = vim.g.autoformat
				end
				if not effective then
					return
				end
				return { timeout_ms = 3000, lsp_format = "fallback" }
			end,
		})

		-- Default global autoformat on. Set before first BufWritePre can fire.
		if vim.g.autoformat == nil then
			vim.g.autoformat = true
		end

		Snacks.toggle.new({
			name = "Autoformat (global)",
			get = function()
				return vim.g.autoformat
			end,
			set = function(v)
				vim.g.autoformat = v
			end,
		}):map("<leader>uf")

		Snacks.toggle.new({
			name = "Autoformat (buffer)",
			get = function()
				local buf = vim.b.autoformat
				if buf == nil then
					return vim.g.autoformat
				end
				return buf
			end,
			set = function(v)
				vim.b.autoformat = v
			end,
		}):map("<leader>uF")

		-- Format keymap
		vim.keymap.set({ "n", "v" }, "<leader>frm", function()
			require("conform").format({
				lsp_fallback = true,
				async = false,
			})
		end, { desc = "Format file or range" })
	end,
}
