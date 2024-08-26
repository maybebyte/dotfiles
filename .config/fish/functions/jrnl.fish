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

	mkdir -p (string replace --regex '/[0-9]{4}-[0-9]{2}-[0-9]{2}\.txt\.gpg$' '' {$JRNL_ENTRY})

	{$EDITOR} {$JRNL_ENTRY}
end
