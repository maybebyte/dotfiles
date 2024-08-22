cpbak() {
	if [ -z "$1" ] || [ "$1" = '-h' ]; then
		cat >&2 <<-EOF
			If the given file ends in ".bak", create a copy of that file
			without ".bak" at the end. Otherwise, create a copy of
			that file with ".bak" at the end.

			cpbak [file]
		EOF

		return
	fi

	CPBAK_FILE="$1"

	if [ -n "${CPBAK_FILE##*.bak}" ]; then
		cp -- "${CPBAK_FILE}" "${CPBAK_FILE}.bak"
	else
		cp -- "${CPBAK_FILE}" "${CPBAK_FILE%.bak}"
	fi

	unset CPBAK_FILE
}

mvbak() {
	if [ -z "$1" ] || [ "$1" = '-h' ]; then
		cat >&2 <<-EOF
			If the given file ends in ".bak", remove ".bak" from the
			filename. Otherwise, append ".bak" to the filename.

			mvbak [file]
		EOF

		return
	fi

	MVBAK_FILE="$1"

	if [ -n "${MVBAK_FILE##*.bak}" ]; then
		mv -- "${MVBAK_FILE}" "${MVBAK_FILE}.bak"
	else
		mv -- "${MVBAK_FILE}" "${MVBAK_FILE%.bak}"
	fi

	unset MVBAK_FILE
}


# journal
jrnl() {
	case "$@" in
		'') # being used as intended
			;;

		'-h' | *)
			cat >&2 <<-EOF
				jrnl (for journaling) takes no arguments.

				It creates ${HOME}/notes/journal/$(date '+%F').txt.gpg (including the directory
				tree, if it doesn't exist) and then opens up the file in ${EDITOR:-EDITOR}.
			EOF

			return
			;;
	esac

	if [ -z "${EDITOR}" ]; then
		echo 'jrnl() needs EDITOR to be defined.' >&2
		return 1
	fi

	TODAY="$(date '+%F')"
	JRNL_ENTRY="${HOME}/notes/journal/${TODAY}.txt.gpg"

	# easier to just create the directory than error
	mkdir -p "${JRNL_ENTRY%/*}"

	"${EDITOR}" "${JRNL_ENTRY}"
}

ytpl() {
	yt-dlp \
		--download-archive './archive.txt' \
		--output './%(title)s.%(ext)s' \
		--match-filter "playlist_title != 'Liked videos' & playlist_title != 'Favorites'" \
		"$@"
}

ebin() { fzf-open "${EDITOR}" "${XDG_BIN_HOME}"; }
econf() { fzf-open "${EDITOR}" "${XDG_CONFIG_HOME}"; }
eman() { fzf-open "${EDITOR}" "${XDG_DATA_HOME}/man"; }
enotes() { fzf-open "${EDITOR}" "${HOME}/notes"; }
