
MC_PATH="/home/${MC_USER}/${MC_DIR}"


function do_start() {
	title C "Starting service.." "$1"
	echo "  user: $MC_USER"
	echo "  path: $MC_PATH"
}

function do_stop() {
	title C "Stopping service.." "$1"
}

function do_restart() {
	do_stop  "$1"
	do_start "$1"
}

function do_reload() {
	title C "Reloading service.." "$1"
}

function do_save() {
	title C "Saving.." "$1"
}
