#!/usr/bin/bash
set -e

APP_HOME="$HOME/.local/share/android_studio_canary"

mkdir -p "$APP_HOME"

function launch(){
	bwrap \
	--die-with-parent \
	--symlink usr/lib /lib \
	--symlink usr/lib64 /lib64 \
	--symlink usr/bin /bin \
	--symlink usr/bin /sbin \
	--ro-bind /opt /opt \
	--ro-bind /etc /etc \
	--ro-bind /usr /usr \
	--dev /dev \
	--dev-bind /dev/dri /dev/dri \
	--proc /proc \
	--ro-bind /sys/dev/char /sys/dev/char \
	--ro-bind /sys/devices /sys/devices \
	--ro-bind /run/dbus /run/dbus \
	--bind "$XDG_RUNTIME_DIR" "$XDG_RUNTIME_DIR" \
	--bind /tmp /tmp \
	--bind "$APP_HOME" "$HOME" \
	--bind "$XDG_CONFIG_HOME" "$XDG_CONFIG_HOME" \
	--bind "$XDG_CACHE_HOME" "$XDG_CACHE_HOME" \
	--bind "$XDG_DATA_HOME" "$XDG_DATA_HOME" \
	--bind "$HOME"/Android "$HOME"/Android \
	/usr/bin/bash "$@"
	exit $?
}

launch "$@"
