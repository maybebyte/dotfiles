function ytpl --wraps='yt-dlp'
	yt-dlp \
		--download-archive './archive.txt' \
		--output './%(title)s.%(ext)s' \
		--match-filter "playlist_title != 'Liked videos' & playlist_title != 'Favorites'" \
		{$argv}
end
