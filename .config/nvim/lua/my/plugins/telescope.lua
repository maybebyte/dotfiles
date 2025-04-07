-- luacheck: globals vim

-- Configure file navigation keymaps
local function setup_file_navigation_keymaps()
	vim.keymap.set("n", "<leader>ts", function()
		vim.cmd("Telescope")
	end, { desc = "[T]ele[S]cope" })

	vim.keymap.set("n", "<leader>sf", function()
		require("telescope.builtin").find_files()
	end, { desc = "[S]earch [F]iles" })

	vim.keymap.set("n", "<leader>gf", function()
		require("telescope.builtin").git_files()
	end, { desc = "Search [G]it [F]iles" })

	vim.keymap.set("n", "<leader>/", function()
		-- You can pass additional configuration to telescope to change theme, layout, etc.
		require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
			winblend = 10,
			previewer = false,
		}))
	end, { desc = "[/] Fuzzily search in current buffer" })

	vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
end

-- Configure search and grep keymaps
local function setup_search_keymaps()
	vim.keymap.set("n", "<leader>sh", function()
		require("telescope.builtin").help_tags()
	end, { desc = "[S]earch [H]elp" })

	vim.keymap.set("n", "<leader>sw", function()
		require("telescope.builtin").grep_string({
			search = vim.fn.input("Grep > "),
		})
	end, { desc = "[S]earch current [W]ord" })

	vim.keymap.set("n", "<leader>sg", function()
		require("telescope.builtin").live_grep()
	end, { desc = "[S]earch by [G]rep" })
end

-- Configure LSP-related keymaps
local function setup_lsp_keymaps()
	vim.keymap.set("n", "<leader>sd", function()
		require("telescope.builtin").diagnostics()
	end, { desc = "[S]earch [D]iagnostics" })

	vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "[G]oto [R]eferences" })

	vim.keymap.set("n", "gI", require("telescope.builtin").lsp_implementations, { desc = "[G]oto [I]mplementation" })

	vim.keymap.set(
		"n",
		"<leader>ds",
		require("telescope.builtin").lsp_document_symbols,
		{ desc = "[D]ocument [S]ymbols" }
	)

	vim.keymap.set(
		"n",
		"<leader>ws",
		require("telescope.builtin").lsp_dynamic_workspace_symbols,
		{ desc = "[W]orkspace [S]ymbols" }
	)
end

-- Configure DAP extension keymaps
local function setup_dap_keymaps()
	vim.keymap.set("n", "<leader>dtb", function()
		require("telescope").extensions.dap.list_breakpoints()
	end, { desc = "[D]ebug [T]elescope [B]reakpoints" })

	vim.keymap.set("n", "<leader>dtc", function()
		require("telescope").extensions.dap.commands()
	end, { desc = "[D]ebug [T]elescope [C]ommands" })

	vim.keymap.set("n", "<leader>dtf", function()
		require("telescope").extensions.dap.frames()
	end, { desc = "[D]ebug [T]elescope [F]rames" })

	-- https://github.com/nvim-telescope/telescope-dap.nvim/pull/17
	-- vim.keymap.set("n", "<leader>dtv", function()
	--     require("telescope").extensions.dap.variables()
	-- end, { desc = "[D]ebug [T]elescope [V]ariables" })
end

return {
	"nvim-telescope/telescope.nvim",
	lazy = true,
	tag = "0.1.2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = function()
				vim.cmd("!gmake")
			end,
		},
		{
			"nvim-telescope/telescope-dap.nvim",
			dependencies = "mfussenegger/nvim-dap",
		},
	},
	keys = {
		{ "<leader>ts" },
		{ "<leader>sf" },
		{ "<leader>gf" },
		{ "<leader>sh" },
		{ "<leader>sw" },
		{ "<leader>sg" },
		{ "<leader>sd" },
		{ "<leader>dtb" },
		{ "<leader>dtc" },
		{ "<leader>dtf" },
		-- { "<leader>dtv" },
		{ "<leader>as" },
		{ "<leader>/" },
		{ "<leader>?" },
		{ "gr" },
		{ "gI" },
		{ "<leader>ds" },
		{ "<leader>ws" },
	},
	cmd = { "Telescope" },
	config = function()
		require("telescope").setup({})
		require("telescope").load_extension("dap")

		-- Setup keymaps by functionality groups
		setup_file_navigation_keymaps()
		setup_search_keymaps()
		setup_lsp_keymaps()
		setup_dap_keymaps()
	end,
}
