#!/run/current-system/sw/bin/env sh

# Usage:
# `record`: Ask for recording type via dmenu
# `record screencast`: Record both audio and screen
# `record video`: Record only screen
# `record audio`: Record only audio
# `record kill`: Kill existing recording
#
# If there is already a running instance, user will be prompted to end it.

updateicon() { \
	echo "$1" > /tmp/recordingicon
	pkill -RTMIN+9 i3blocks
	}

killrecording() {
	recpid="$(cat /tmp/recordingpid)"
	# kill with SIGTERM, allowing finishing touches.
	kill -15 "$recpid"
	rm -f /tmp/recordingpid
	updateicon ""
	pkill -RTMIN+9 i3blocks
	# even after SIGTERM, ffmpeg may still run, so SIGKILL it.
	sleep 3
	kill -9 "$recpid"
	exit
	}

screencast() { \
	ffmpeg -y \
	-f x11grab \
	-framerate 60 \
	-s $(xdpyinfo | grep dimensions | awk '{print $2;}') \
	-i $DISPLAY \
	-f alsa -i default \
	-r 30 \
 	-c:v libx264rgb -crf 0 -preset ultrafast -c:a flac \
	"$HOME/recordings/screencast-$(date '+%y%m%d-%H%M-%S').mkv" &
	echo $! > /tmp/recordingpid
	updateicon "⏺️🎙️"
       	}

video() { ffmpeg \
	-f x11grab \
	-s $(xdpyinfo | grep dimensions | awk '{print $2;}') \
	-i $DISPLAY \
 	-c:v libx264 -qp 0 -r 30 \
	"$HOME/recordings/video-$(date '+%y%m%d-%H%M-%S').mkv" &
	echo $! > /tmp/recordingpid
	updateicon "⏺️"
	}

webcamhidef() { ffmpeg \
	-f v4l2 \
	-i /dev/video0 \
	-video_size 1920x1080 \
	"$HOME/recordings/webcam-$(date '+%y%m%d-%H%M-%S').mkv" &
	echo $! > /tmp/recordingpid
	updateicon "🎥"
	}

webcam() { ffmpeg \
	-f v4l2 \
	-i /dev/video0 \
	-video_size 640x480 \
	"$HOME/recordings/webcam-$(date '+%y%m%d-%H%M-%S').mkv" &
	echo $! > /tmp/recordingpid
	updateicon "🎥"
	}


audio() { \
	ffmpeg \
	-f alsa -i default \
	-c:a flac \
	"$HOME/recordings/audio-$(date '+%y%m%d-%H%M-%S').flac" &
	echo $! > /tmp/recordingpid
	updateicon "🎙️"
	}

askrecording() { \
	choice=$(printf "screencast\\nvideo\\naudio\\nwebcam\\nwebcam (hi-def)" | dmenu -i -p "Select recording style:")
	case "$choice" in
		screencast) screencast;;
		audio) audio;;
		video) video;;
		webcam) webcam;;
		"webcam (hi-def)") webcamhidef;;
	esac
	}

asktoend() { \
	response=$(printf "No\\nYes" | dmenu -i -p "Recording still active. End recording?") &&
	[ "$response" = "Yes" ] &&  killrecording
	}


case "$1" in
	screencast) screencast;;
	audio) audio;;
	video) video;;
	kill) killrecording;;
	*) ([ -f /tmp/recordingpid ] && asktoend && exit) || askrecording;;
esac

