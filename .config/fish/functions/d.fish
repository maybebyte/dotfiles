# Manage dotfiles more easily.
function d --wraps='git'
	git --git-dir={$HOME}/.dotfiles/ --work-tree={$HOME}/ {$argv}
end
