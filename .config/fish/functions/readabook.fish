function readabook
	if not set -q READER
		set --function READER 'zathura'
	end
	fzf-open {$READER} {$HOME}/books
end
