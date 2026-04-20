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
				-- D-16 support: advertise inlayHintProvider so the LspAttach
				-- callback's supports_method check returns true for lua_ls.
				hint = { enable = true },
			},
		},
	})

	vim.lsp.config('pyright', {
		settings = {
			pyright = { disableLanguageServices = true },
		},
	})

	-- D-06 expansion: 10 new servers. Only ts_ls needs an explicit settings
	-- block (Pitfall 6: inlayHints require server-side enablement via settings).
	-- Other servers work with defaults; mason-lspconfig automatic_enable picks
	-- them up after this function finishes.

	-- ts_ls: inlayHints only appear if the server is told to compute them.
	vim.lsp.config('ts_ls', {
		settings = {
			typescript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
				},
			},
			javascript = {
				inlayHints = {
					includeInlayParameterNameHints = "all",
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
				},
			},
		},
	})

	-- gopls/rust_analyzer: defaults produce inlay hints out of the box.
	vim.lsp.config('gopls', {})
	vim.lsp.config('rust_analyzer', {})

	-- bashls: default config functional.
	vim.lsp.config('bashls', {})

	-- cssls/html/jsonls/yamlls: defaults fine (snippetSupport injected globally
	-- via vim.lsp.config('*', { capabilities }) above).
	vim.lsp.config('cssls', {})
	vim.lsp.config('html', {})
	vim.lsp.config('jsonls', {})
	vim.lsp.config('yamlls', {})

	-- stylelint_lsp: Pitfall 5 notes its default filetypes include JS/TS which
	-- can duplicate ts_ls diagnostics on mixed projects. Keep defaults for now;
	-- restrict reactively if friction surfaces.
	vim.lsp.config('stylelint_lsp', {})

	-- marksman: default config functional.
	vim.lsp.config('marksman', {})

	require("mason-lspconfig").setup()
end

return {
	"neovim/nvim-lspconfig",
	lazy = true,
	cmd = { "LspInfo", "LspInstall", "LspStart" },
	event = { "BufReadPost", "BufNewFile", "FileType" },
	dependencies = {
		-- Mason for LSP server management (mason.nvim is top-level now; see mason.lua)
		{ "williamboman/mason-lspconfig.nvim", version = "v2.*" },

		-- Completion capabilities for nvim-cmp
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		setup_lsp_diagnostics()

		-- Pitfall 3 fix: missing `clear = true` caused duplicate LspAttach handlers
		-- on config re-source (doubles inlay_hint.enable calls).
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
			callback = function(ev)
				setup_keybinds_on_attach(ev.buf)

				-- D-16/D-21: enable inlay hints only if the attached client
				-- advertises textDocument/inlayHint. No-op otherwise — no error,
				-- no visual glitch (success criterion #4).
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client and client:supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
				end
			end,
		})
		setup_lsp_servers()
	end,
}
