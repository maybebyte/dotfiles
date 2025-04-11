return {
	"nvim-telescope/telescope-ui-select.nvim",
	lazy = true,
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	init = function()
		vim.api.nvim_create_autocmd("UIEnter", {
			callback = function()
				-- By this point, vim.ui.select should be fully initialized
				local original_ui_select = vim.ui.select
				local telescope_select_loaded = false

				vim.ui.select = function(items, opts, on_choice)
					if not telescope_select_loaded then
						-- Try to load telescope and its ui-select extension
						local status_ok, _ = pcall(function()
							require("telescope")
							require("telescope").load_extension("ui-select")
							telescope_select_loaded = true
						end)

						-- If loaded successfully, the extension has already
						-- replaced vim.ui.select, so we just call it
						if status_ok then
							return vim.ui.select(items, opts, on_choice)
						end
					end

					-- Call the original implementation
					return original_ui_select(items, opts, on_choice)
				end
			end,
			once = true,
		})
	end,
}
