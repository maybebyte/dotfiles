-- luacheck: globals vim

-- D-13: mason.nvim as standalone top-level plugin spec.
-- lazy=false + priority=100 ensures PATH prepend completes BEFORE
-- lspconfig (BufReadPost/BufNewFile) and mason-tool-installer (lazy=false)
-- attempt to look up installed tools.
return {
	"williamboman/mason.nvim",
	version = "v2.*",
	lazy = false,
	priority = 100,
	opts = {},
}
