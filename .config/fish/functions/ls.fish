# Replace ls with eza if available
# https://github.com/eza-community/eza
if command --search --quiet 'eza'
	function ls --wraps='eza'
		eza --icons --classify {$argv}
	end
end
