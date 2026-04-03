


if ! pgrep -x mpd > /dev/null; then
    mpd
fi

export MPD_HOST=/tmp/mpd.socket

