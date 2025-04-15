-- NOTE: nvim-autopairs README mentions this regarding nvim-cmp:
-- "You need to add mapping `CR` on nvim-cmp setup. Check readme.md on nvim-cmp repo."
--
-- However, I've had no issues so far? Writing a comment here in case I run into issues later.
return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = {},
}
