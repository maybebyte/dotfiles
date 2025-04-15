-- luacheck: globals vim

-- Configure file navigation keymaps
local function setup_file_navigation_keymaps()
	vim.keymap.set("n", "<leader>ts", function()
		require("telescope.builtin").builtin()
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

	vim.keymap.set(
		"n",
		"<leader>s.",
		require("telescope.builtin").oldfiles,
		{ desc = '[S]earch Recent Files ("." for repeat)' }
	)
	-- Shortcut for searching your Neovim configuration files
	vim.keymap.set("n", "<leader>sn", function()
		require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
	end, { desc = "[S]earch [N]eovim files" })

	vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })

	vim.keymap.set(
		"n",
		"<leader><leader>",
		require("telescope.builtin").buffers,
		{ desc = "[ ] Find existing buffers" }
	)
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
end

return {
	"nvim-telescope/telescope.nvim",
	lazy = true,
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "gmake",
			cond = function()
				return vim.fn.executable("gmake") == 1
			end,
		},
		{
			"nvim-telescope/telescope-dap.nvim",
			dependencies = "mfussenegger/nvim-dap",
		},
	},
	keys = {
		-- File Navigation keymaps
		{ "<leader>ts" },
		{ "<leader>sf" },
		{ "<leader>gf" },
		{ "<leader>/" },
		{ "<leader>s." },
		{ "<leader>sn" },
		{ "<leader>sr" },
		{ "<leader><leader>" },

		-- Search keymaps
		{ "<leader>sh" },
		{ "<leader>sw" },
		{ "<leader>sg" },

		-- LSP-related keymaps
		{ "<leader>sd" },
		{ "gr" },
		{ "gI" },
		{ "<leader>ds" },
		{ "<leader>ws" },

		-- DAP extension keymaps
		{ "<leader>dtb" },
		{ "<leader>dtc" },
		{ "<leader>dtf" },
	},
	cmd = { "Telescope" },
	config = function()
		require("telescope").setup({
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})
		require("telescope").load_extension("dap")
		require("telescope").load_extension("fzf")

		-- Setup keymaps by functionality groups
		setup_file_navigation_keymaps()
		setup_search_keymaps()
		setup_lsp_keymaps()
		setup_dap_keymaps()
	end,
}
