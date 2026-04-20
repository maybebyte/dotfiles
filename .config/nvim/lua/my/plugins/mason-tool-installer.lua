-- luacheck: globals vim

-- D-01/D-02/D-03/D-04/D-05: sole toolchain provisioner.
-- lazy=false is MANDATORY — `event = "VimEnter"` or `event = "VeryLazy"` silently
-- skip run_on_start (plugin not loaded by the time VimEnter fires).
-- See .planning/phases/03-lsp-tool-provisioning/03-RESEARCH.md Pitfall 1.
--
-- D-06: LSP server list uses lspconfig short names; mason-lspconfig
-- integration (enabled by default) translates to Mason registry names.
-- D-11/D-12: conform.lua and nvim-lint.lua keep their own ft→tool maps;
-- this file is the INSTALLATION source of truth, they are USAGE.
return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	lazy = false,
	dependencies = { "williamboman/mason.nvim" },
	opts = {
		ensure_installed = {
			-- LSP servers (D-06, 12 total — lspconfig names)
			"lua_ls",
			"pyright",
			"gopls",
			"bashls",
			"rust_analyzer",
			"ts_ls",
			"cssls",
			"html",
			"jsonls",
			"yamlls",
			"stylelint_lsp",
			"marksman",

			-- Formatters (from conform.lua formatters_by_ft — Mason registry names)
			"stylua",
			"prettier",
			"gofumpt",
			"black",
			"shfmt",
			-- perltidy: not in mason registry; install manually (cpan install Perl::Tidy)
			-- clang-format is typically system-installed; not added to ensure_installed
			"tex-fmt",
			"xmlformatter",

			-- Linters (from nvim-lint.lua linters_by_ft — Mason registry names)
			"revive",
			"luacheck",
			"selene",
			"markdownlint",
			"mypy",
			"pylint",
			"ruff",
			"erb-lint",
		},
		auto_update = false, -- D-03: install-missing only, no silent drift
		run_on_start = true, -- D-02: async install on VimEnter
		-- vim.notify default (D-04): visible bootstrap confirmation
	},
}
