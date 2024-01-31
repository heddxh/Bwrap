#!/usr/bin/bash
set -e

STEAM_HOME="$HOME/.local/share/steam-sandbox"
RUN_USER="$XDG_RUNTIME_DIR"

mkdir -p "$STEAM_HOME"

_bind() {
	_bind_arg=$1
	shift
	for _path in "$@"; do
		args+=("$_bind_arg" "$_path" "$_path")
	done
}

bind() {
	_bind --bind-try "$@"
}

robind() {
	_bind --ro-bind-try "$@"
}

devbind() {
	_bind --dev-bind-try "$@"
}

args=(
	--tmpfs /tmp
	--proc /proc
	--dev /dev
	--dir /etc
	--dir /var
	--dir "$RUN_USER"
	--bind "$STEAM_HOME" "$HOME"
	--dir "$HOME"
	--dir "$XDG_CONFIG_HOME"
	--dir "$XDG_CACHE_HOME"
	--dir "$XDG_DATA_HOME"
	--dir "$XDG_STATE_HOME"
	--symlink /usr/lib /lib
	--symlink /usr/lib /lib64
	--symlink /usr/bin /bin
	--symlink /usr/bin /sbin
	--symlink /run /var/run
)

robind \
	/usr \
	/etc \
	/opt \
	/sys \
	/var/empty \
	/var/lib/alsa \
	/var/lib/dbus \
	"$RUN_USER/systemd/resolve"

devbind \
	/dev/dri

# VScode
bind \
	"$XAUTHORITY" \
	"$HOME/.pki" \
	"$HOME/Downloads" \
	"$HOME/.local/share/Steam" \
	"$RUN_USER"/dbus* \
	"$RUN_USER"/pipewire* \
	"$RUN_USER"/pulse* \
	"$RUN_USER"/wayland* \
	"$RUN_USER/at-spi" \
	"$RUN_USER/bus" \
	"$RUN_USER/dconf" \
	"$RUN_USER/systemd" \
	"$XDG_CACHE_HOME/mesa_shader_cache" \
	"$XDG_CACHE_HOME/nv" \
	"$XDG_CACHE_HOME/nvidia" \
	"$XDG_CACHE_HOME/radv_builtin_shaders64" \
	"$XDG_CONFIG_HOME/pulse" \
	"$XDG_DATA_HOME/applications" \
	"$XDG_DATA_HOME/icons" \
	"$XDG_DATA_HOME/vpltd" \
	"$XDG_DATA_HOME/vulkan" \
	"/var/lib/bluetooth" \
	/run/systemd \
	/tmp/.ICE-unix \
	/tmp/.X11-unix

exec bwrap "${args[@]}" env STEAM_FORCE_DESKTOPUI_SCALING=1.25 GTK_IM_MODULE=xim /usr/lib/steam/steam "$@"
