function cpbak
	if ! string length --quiet -- {$argv[1]} || contains -- -h {$argv} || contains -- --help {$argv}
		echo 'If the given file ends in ".bak", create a copy of that file
without ".bak" at the end. Otherwise, create a copy of
that file with ".bak" at the end.

cpbak [file]' >&2
		return
	end

	set --local CPBAK_FILE {$argv[1]}

	if string match --quiet --regex '\.bak$' {$CPBAK_FILE}
		cp -- {$CPBAK_FILE} (string replace --regex '\.bak$' '' {$CPBAK_FILE})
	else
		cp -- {$CPBAK_FILE} {$CPBAK_FILE}.bak
	end

	set --erase CPBAK_FILE
end
