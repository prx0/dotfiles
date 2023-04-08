#!/usr/bin/env bash

function is_immutable_os {
	declare -A name_exp_ht=(
		["ilverblue"]="Fedora Silverblue"
		["inoite"]="Fedora Kinoite"
	)

	local etc_release=$(cat /etc/*-release)

	# test if we are using an immutable os
	for name_exp in "${!name_exp_ht[@]}"; do
		if echo $etc_release | grep -q "${name_exp}";  then
			echo -e "Immutable OS detected ${name_exp_ht[$name_exp]}"
			return 0
		fi
	done

	return 1
}

function jump_into_container {
	if [[ -z "${container}" ]]; then
		local container_name="${1:-f37}"
		echo "load container ${container_name}"
		distrobox enter "${container_name}"
	else
		echo -e "I'm in!"
	fi
}

if is_immutable_os; then
	jump_into_container
fi