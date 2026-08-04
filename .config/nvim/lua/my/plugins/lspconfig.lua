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

local function inlay_hints_enabled(bufnr)
	local buffer_override = vim.b[bufnr].inlay_hints
	if buffer_override ~= nil then
		return buffer_override
	end
	return vim.g.inlay_hints
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

	local utils = require("my.utils")
	vim.keymap.set("n", "[d", utils.diagnostic_goto(false), { desc = "Go to previous diagnostic" })
	vim.keymap.set("n", "]d", utils.diagnostic_goto(true), { desc = "Go to next diagnostic" })
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
				-- Advertise inlayHintProvider so the LspAttach callback's
				-- supports_method check returns true for lua_ls.
				hint = { enable = true },
			},
		},
	})

	-- Only ts_ls and gopls need explicit settings; inlayHints require
	-- server-side enablement. Other servers use defaults; mason-lspconfig
	-- automatic_enable picks them up after this function finishes.

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

	-- gopls: hints require explicit server-side enablement via settings.
	-- All 7 canonical hint types enabled to match the ts_ls pattern.
	vim.lsp.config('gopls', {
		settings = {
			gopls = {
				hints = {
					assignVariableTypes    = true,
					compositeLiteralFields = true,
					compositeLiteralTypes  = true,
					constantValues         = true,
					functionTypeParameters = true,
					parameterNames         = true,
					rangeVariableTypes     = true,
				},
			},
		},
	})
	-- pyright, bashls, rust_analyzer, cssls, html, jsonls, yamlls, stylelint_lsp,
	-- marksman, terraformls: use defaults; capabilities are injected via the
	-- '*' config above, and mason-lspconfig.automatic_enable picks them up
	-- after setup.
	-- stylelint_lsp default filetypes include JS/TS which can duplicate ts_ls
	-- diagnostics on mixed projects; restrict reactively if friction surfaces.
	-- These tool-only clients are excluded from automatic LSP enablement:
	-- Conform owns StyLua formatting, while nvim-lint owns Ruff and TFLint
	-- diagnostics. Starting their LSP clients would duplicate that work.
	require("mason-lspconfig").setup({
		automatic_enable = {
			exclude = { "ruff", "stylua", "tflint" },
		},
	})
end

return {
	"neovim/nvim-lspconfig",
	lazy = true,
	cmd = { "LspInfo", "LspInstall", "LspStart" },
	event = "FileType",
	dependencies = {
		-- Mason for LSP server management (mason.nvim is top-level now; see mason.lua)
		{ "williamboman/mason-lspconfig.nvim", version = "v2.*" },

		-- Completion capabilities for nvim-cmp
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		setup_lsp_diagnostics()

		-- `clear = true` prevents duplicate LspAttach handlers on config
		-- re-source (which would double inlay_hint.enable calls).
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
			callback = function(ev)
				setup_keybinds_on_attach(ev.buf)

				-- Enable inlay hints only if the attached client advertises
				-- textDocument/inlayHint. No-op otherwise — no error, no glitch.
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client and client:supports_method("textDocument/inlayHint") then
					vim.lsp.inlay_hint.enable(inlay_hints_enabled(ev.buf), { bufnr = ev.buf })
				end
			end,
		})

		-- The `vim.g.inlay_hints` default is established unconditionally at
		-- startup in lua/my/settings/vim_g.lua so it is set even if no
		-- buffer event (BufReadPost / FileType / LspAttach) ever fires.
		--
		-- Snacks.toggle:map() uses the toggle `name` as the keymap desc
		-- automatically, which is why the :map("<leader>uH") / :map("<leader>uh")
		-- calls below look desc-less compared to other keymaps in this file.
		Snacks.toggle.new({
			name = "Inlay Hints (global)",
			get = function()
				return vim.g.inlay_hints
			end,
			set = function(v)
				vim.g.inlay_hints = v
				vim.lsp.inlay_hint.enable(v)
				for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
					local buffer_override = vim.b[bufnr].inlay_hints
					if buffer_override ~= nil and vim.api.nvim_buf_is_loaded(bufnr) then
						vim.lsp.inlay_hint.enable(buffer_override, { bufnr = bufnr })
					end
				end
			end,
		}):map("<leader>uH")

		Snacks.toggle.new({
			name = "Inlay Hints (buffer)",
			get = function()
				return inlay_hints_enabled(0)
			end,
			set = function(v)
				vim.b.inlay_hints = v
				vim.lsp.inlay_hint.enable(v, { bufnr = 0 })
			end,
		}):map("<leader>uh")

		setup_lsp_servers()
	end,
}
