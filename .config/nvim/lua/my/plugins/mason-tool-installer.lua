-- luacheck: globals vim

-- Sole toolchain provisioner. `lazy = false` is mandatory: `event = "VimEnter"`
-- or `VeryLazy` silently skip run_on_start (plugin not loaded yet when VimEnter
-- fires). Manual-only tools (not in the Mason registry): perltidy (`cpan install
-- Perl::Tidy`), clang-format (system package).
return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	lazy = false,
	dependencies = { "williamboman/mason.nvim" },
	opts = {
		ensure_installed = {
			-- LSP servers (lspconfig short names; mason-lspconfig translates)
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
		auto_update = false, -- install-missing only, no silent drift
		run_on_start = true, -- async install on VimEnter
	},
}
