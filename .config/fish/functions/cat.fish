# Replace cat and less with bat if available
# https://github.com/sharkdp/bat
if command --search --quiet 'bat'
	function cat --wraps='bat'
		bat {$argv}
	end
end
