# Replace vi and vim commands with neovim if available.
if command --search --quiet 'nvim'
	function vi --wraps='nvim'
		nvim {$argv}
	end
end
