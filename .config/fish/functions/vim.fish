# Replace vi and vim commands with neovim if available.
if command --search --quiet 'nvim'
	function vim --wraps='nvim'
		nvim {$argv}
	end
end
