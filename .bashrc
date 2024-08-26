# Test for an interactive shell. There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
case "$-" in
	*i*) true   ;; # interactive
	*)   return ;; # not interactive
esac

# If fish is available, use fish.
if command -v 'fish'; then
	SHELL="$(command -v 'fish')"
	exec "${SHELL}"
fi
