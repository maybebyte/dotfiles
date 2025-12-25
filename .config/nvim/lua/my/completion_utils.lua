-- Shared completion utilities
-- Used by completion.lua, copilot.lua, and any plugin that needs to reconfigure cmp

-- Require Neovim 0.9+ for vim.uv, vim.schedule, etc.
if vim.fn.has("nvim-0.9") ~= 1 then
	vim.notify("[cmp] completion_utils requires Neovim 0.9+", vim.log.levels.ERROR)
	return {}
end

local M = {}

-- Debug logging (set NVIM_CMP_DEBUG=1 to enable)
local function log(msg)
	if vim.env.NVIM_CMP_DEBUG then
		vim.notify("[cmp] " .. msg, vim.log.levels.DEBUG)
	end
end

function M.get_completion_sources()
	local copilot_loaded = package.loaded["copilot_cmp"] ~= nil
	local luasnip_loaded = package.loaded["cmp_luasnip"] ~= nil
	local lazydev_loaded = package.loaded["lazydev"] ~= nil
	log(
		string.format(
			"Sources check: copilot=%s, luasnip=%s, lazydev=%s",
			tostring(copilot_loaded),
			tostring(luasnip_loaded),
			tostring(lazydev_loaded)
		)
	)

	local sources = {
		{ name = "nvim_lsp", priority = 900 },
		{ name = "nvim_lua", priority = 800 },
		{ name = "path", priority = 300 },
		{ name = "buffer", priority = 200, keyword_length = 3 },
	}

	if copilot_loaded then
		table.insert(sources, 1, { name = "copilot", priority = 1000 })
	end
	if luasnip_loaded then
		table.insert(sources, { name = "luasnip", priority = 750 })
	end
	if lazydev_loaded then
		table.insert(sources, 1, { name = "lazydev", group_index = 0 })
	end

	return sources
end

function M.expand_snippet(args)
	local luasnip_ok, luasnip = pcall(require, "luasnip")
	if luasnip_ok then
		luasnip.lsp_expand(args.body)
	elseif vim.fn.has("nvim-0.10") == 1 then
		vim.snippet.expand(args.body)
	else
		vim.notify("[cmp] Snippet expansion requires LuaSnip or Neovim 0.10+", vim.log.levels.WARN)
	end
end

-- Helper to create navigation mappings with configurable modes
local function get_nav_mapping(cmp, modes, direction)
	assert(direction == "next" or direction == "prev", "direction must be 'next' or 'prev'")
	local select_fn = direction == "next" and cmp.select_next_item or cmp.select_prev_item
	return cmp.mapping(function(fallback)
		if cmp.visible() then
			select_fn()
		else
			fallback()
		end
	end, modes)
end

-- Base mappings used by both variants
local function get_base_mappings(cmp, modes)
	return {
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-n>"] = get_nav_mapping(cmp, modes, "next"),
		["<C-p>"] = get_nav_mapping(cmp, modes, "prev"),
		["<C-y>"] = cmp.mapping.confirm(),
		["<C-Space>"] = cmp.mapping.complete(),
	}
end

-- Keymappings without snippet support (for CmdlineEnter before LuaSnip loads)
function M.get_keymappings_no_snippets(cmp)
	return get_base_mappings(cmp, { "i" })
end

-- Full keymappings with LuaSnip snippet support
function M.get_keymappings(cmp, luasnip)
	local mappings = get_base_mappings(cmp, { "i", "s" })

	mappings["<C-f>"] = cmp.mapping(function(fallback)
		if luasnip.jumpable(1) then
			luasnip.jump(1)
		else
			fallback()
		end
	end, { "i", "s" })

	mappings["<C-b>"] = cmp.mapping(function(fallback)
		if luasnip.jumpable(-1) then
			luasnip.jump(-1)
		else
			fallback()
		end
	end, { "i", "s" })

	return mappings
end

local reconfigure_pending = false

function M.reconfigure_cmp()
	if reconfigure_pending then
		log("Reconfigure already pending, skipping")
		return
	end
	reconfigure_pending = true

	vim.schedule(function()
		local success, err = pcall(function()
			reconfigure_pending = false

			local ok, cmp = pcall(require, "cmp")
			if not ok then
				log("cmp not loaded yet, skipping reconfigure")
				return
			end
			local luasnip_ok, luasnip = pcall(require, "luasnip")

			log("Reconfiguring cmp (luasnip loaded: " .. tostring(luasnip_ok) .. ")")

			local config = {
				sources = M.get_completion_sources(),
				mapping = luasnip_ok and M.get_keymappings(cmp, luasnip) or M.get_keymappings_no_snippets(cmp),
				snippet = { expand = M.expand_snippet },
			}

			cmp.setup(config)
		end)

		if not success then
			reconfigure_pending = false
			vim.notify("[cmp] Reconfigure failed: " .. tostring(err), vim.log.levels.ERROR)
		end
	end)
end

return M
