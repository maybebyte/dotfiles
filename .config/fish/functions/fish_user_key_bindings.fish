function fish_user_key_bindings
	# Use vim bindings.
	set -gx fish_key_bindings fish_vi_key_bindings

	# Configure fzf integration
	# If fzf.fish plugin is available, use custom keybindings
	# Otherwise fall back to basic fzf integration
	if type -q fzf_configure_bindings
		fzf_configure_bindings --directory=\ct --git_status=\es --git_log=\el
		# Also bind ALT-C to the same directory search as CTRL-T
		bind -M insert \ec _fzf_search_directory
	else if command --search --quiet 'fzf'
		fzf --fish | source
	end

	# Use vim bindings for menu selection (but use CTRL as a prefix to avoid
	# breaking search)
	#
	# TODO: see if I can patch fish so that search mode automatically enables
	# the keys to search again, and regular hjkl can be used?
	bind -M insert \cj 'commandline --paging-mode; and down-or-search; or commandline --function execute'
	bind -M insert \cn 'commandline --paging-mode; and down-or-search; or commandline --function execute'
	bind -M insert \ck 'commandline --paging-mode; and up-or-search'
	bind -M insert \cp 'commandline --paging-mode; and up-or-search; or commandline --function execute'
	bind -M insert \ch 'commandline --paging-mode; and commandline --function backward-char; or commandline --function backward-delete-char'
	bind -M insert \cl 'commandline --paging-mode; and commandline --function forward-char; or commandline --function clear-screen'

	# Bind CTRL-Y to accept-autosuggestion so that I don't need to press
	# right arrow anymore
	bind -M insert \cy accept-autosuggestion
end
