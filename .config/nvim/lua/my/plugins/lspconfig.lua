local function setup_keybinds_on_attach(bufnr)
	vim.keymap.set(
		"n",
		"gd",
		vim.lsp.buf.definition,
		{ buffer = bufnr, desc = "Go to definition of symbol under cursor" }
	)

	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Show documentation for symbol under cursor" })

	-- Telescope LSP keymaps
	vim.keymap.set("n", "gr", function()
		require("telescope.builtin").lsp_references()
	end, { buffer = bufnr, nowait = true, desc = "[G]oto [R]eferences (Telescope)" })

	vim.keymap.set("n", "gI", function()
		require("telescope.builtin").lsp_implementations()
	end, { buffer = bufnr, nowait = true, desc = "[G]oto [I]mplementation (Telescope)" })

	vim.keymap.set(
		"n",
		"<leader>vws",
		vim.lsp.buf.workspace_symbol,
		{ buffer = bufnr, desc = "Search for symbol across workspace" }
	)

	vim.keymap.set(
		"n",
		"<leader>vca",
		vim.lsp.buf.code_action,
		{ buffer = bufnr, desc = "Show code actions for current context" }
	)

	vim.keymap.set(
		"n",
		"<leader>vrr",
		vim.lsp.buf.references,
		{ buffer = bufnr, desc = "Find all references to symbol under cursor" }
	)

	vim.keymap.set(
		"n",
		"<leader>vrn",
		vim.lsp.buf.rename,
		{ buffer = bufnr, desc = "Rename symbol under cursor across files" }
	)

	vim.keymap.set(
		"i",
		"<C-h>",
		vim.lsp.buf.signature_help,
		{ buffer = bufnr, desc = "Show signature help (parameter info)" }
	)

	vim.keymap.set(
		"n",
		"<leader>vf",
		vim.lsp.buf.format,
		{ buffer = bufnr, desc = "Format current buffer with LSP formatter" }
	)
end

local function setup_lsp_diagnostics()
	vim.diagnostic.config({
		virtual_text = true,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "E",
				[vim.diagnostic.severity.WARN] = "W",
				[vim.diagnostic.severity.HINT] = "H",
				[vim.diagnostic.severity.INFO] = "I",
			},
			numhl = {
				[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
				[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
				[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
				[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
			},
		},
		underline = true,
		update_in_insert = false,
		severity_sort = true,
	})

	vim.keymap.set("n", "[d", function()
		vim.diagnostic.jump({ count = -1, float = true })
	end, { desc = "Go to previous diagnostic" })
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.jump({ count = 1, float = true })
	end, { desc = "Go to next diagnostic" })
	vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
end

local function setup_lsp_servers()
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	vim.lsp.config('*', {
		capabilities = capabilities,
	})

	vim.lsp.config('lua_ls', {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = { checkThirdParty = false },
				telemetry = { enable = false },
			},
		},
	})

	vim.lsp.config('pyright', {
		settings = {
			pyright = { disableLanguageServices = true },
		},
	})

	require("mason").setup()
	require("mason-lspconfig").setup()
end

return {
	"neovim/nvim-lspconfig",
	lazy = true,
	cmd = { "LspInfo", "LspInstall", "LspStart" },
	event = { "BufReadPost", "BufNewFile", "FileType" },
	dependencies = {
		-- Mason for LSP server management
		{ "williamboman/mason.nvim", version = "v2.*" },
		{ "williamboman/mason-lspconfig.nvim", version = "v2.*" },

		-- Completion capabilities for nvim-cmp
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		setup_lsp_diagnostics()

		-- Create autocommand for LSP attachment
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				setup_keybinds_on_attach(ev.buf)
			end,
		})
		setup_lsp_servers()
	end,
}
