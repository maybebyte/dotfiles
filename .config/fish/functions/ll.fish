# Replace ls with eza if available
# https://github.com/eza-community/eza
if command --search --quiet 'eza'
	function ll --wraps='eza'
		eza \
			--icons \
			--classify \
			--time-style=long-iso \
			--git \
			--icons \
			--binary \
			--long \
			--group \
			--header \
			--links \
			--octal-permissions {$argv}
	end
end
