# Play audio with mpv.
function mpva --wraps='mpv'
	mpv --no-keep-open --no-resume-playback --no-pause --no-video {$argv}
end
