-- Plenary test harness — explicit spec dedups transitive entries
-- (telescope, undotree, todo-comments) without lazy-lock.json churn (D-02).
-- cmd triggers cover both headless `make test` and interactive
-- `:PlenaryBustedDirectory` (TESTINFRA-07).
return {
	"nvim-lua/plenary.nvim",
	lazy = true,
	cmd = {
		"PlenaryBustedFile",
		"PlenaryBustedDirectory",
	},
}
