function jrnl
	if string length --quiet -- {$argv}
		echo "jrnl (for journaling) takes no arguments.

It creates $HOME/notes/journal/$(date '+%F').txt.gpg (including the directory
tree, if it doesn't exist) and then opens up the file in EDITOR." >&2
		return
	end

	if [ -z {$EDITOR} ]
		echo 'jrnl() needs EDITOR to be defined' >&2
		return 1
	end

	set --local TODAY (date '+%F')
	set --local JRNL_ENTRY {$HOME}/notes/journal/{$TODAY}.txt.gpg

	mkdir -p (string replace --regex "/$TODAY\.txt\.gpg\$" '' {$JRNL_ENTRY})

	set --erase TODAY

	{$EDITOR} {$JRNL_ENTRY}
end
