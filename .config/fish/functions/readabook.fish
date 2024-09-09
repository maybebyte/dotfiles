# TODO: make sure that READER var has a fallback of zathura
function readabook
	fzf-open {$READER} {$HOME}/books
end
