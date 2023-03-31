function jump_into_container {
	if [[ -z "${container}" ]]; then
		local container_name="${1:-f37}"
		echo "load container ${container_name}"
		distrobox enter "${container_name}"
	else
		echo -e "I'm in!"
	fi
}

jump_into_container
