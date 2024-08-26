# Generate diffs between kernel configurations that can be used in
# /etc/kernel/config.d
#
# See also:
# https://wiki.gentoo.org/wiki/Project:Distribution_Kernel#Using_.2Fetc.2Fkernel.2Fconfig.d
function diffkernel --wraps='diff'
	diff --changed-group-format="%>" --unchanged-group-format="" {$argv}
end
