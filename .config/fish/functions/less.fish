# Replace cat and less with bat if available
# https://github.com/sharkdp/bat
if command --search --quiet 'bat'
	function less --wraps='bat'
		bat --paging=always {$argv}
	end
end
