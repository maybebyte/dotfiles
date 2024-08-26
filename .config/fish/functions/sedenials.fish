# Convenience alias for viewing SELinux denials.
function sedenials --wraps='ausearch'
	ausearch -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR -ts boot {$argv}
end
