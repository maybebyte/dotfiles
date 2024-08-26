function mvbak
	if ! string length --quiet -- {$argv[1]} || contains -- -h {$argv} || contains -- --help {$argv}
		echo 'If the given file ends in ".bak", remove ".bak" from the
filename. Otherwise, append ".bak" to the filename.

mvbak [file]' >&2
		return
	end

	set --local MVBAK_FILE {$argv[1]}

	if string match --quiet --regex '\.bak$' {$MVBAK_FILE}
		mv -- {$MVBAK_FILE} (string replace --regex '\.bak$' '' {$MVBAK_FILE})
	else
		mv -- {$MVBAK_FILE} {$MVBAK_FILE}.bak
	end

	set --erase MVBAK_FILE
end
