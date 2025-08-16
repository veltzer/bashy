# azure completion is in /etc/bash_completion.d/azure-cli
# and comes with the azure tools deb package
# 
# Documentation about how to install the azure cli tools:
# https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt

function _install_azurecli_apt() {
	curl --fail --silent --location "https://aka.ms/InstallAzureCLIDeb" | sudo bash
}

function _install_azurecli() {
	# set -e
	local install_dir="${HOME}/install/azurecli"
	local bin_dir="${install_dir}/bin"
	local tmp_dir="/tmp/azurecli_install"
	local tarball="/tmp/azure-cli.tar.gz"

	echo "Installing Azure CLI to ${install_dir}..."

	# Clean up previous installations and temporary files
	rm -rf "${install_dir}" "${tmp_dir}" "${tarball}"
	mkdir -p "${tmp_dir}"

	# Download
	echo "Downloading Azure CLI..."
	curl --fail --location --show-error "https://azurecliprod.blob.core.windows.net/msi/azure-cli-latest.tar.gz" --output "${tarball}"

	# Extract
	echo "Extracting..."
	tar -xzf "${tarball}" -C "${tmp_dir}"

	# Find the extracted directory (it has a versioned name)
	local extracted_dir
	extracted_dir=$(find "${tmp_dir}" -mindepth 1 -maxdepth 1 -type d)

	if [ -z "${extracted_dir}" ]; then
		echo "ERROR: Failed to find extracted directory." >&2
		exit 1
	fi

	# Run the install script non-interactively
	echo "Running install script from ${extracted_dir}..."
	"${extracted_dir}/install" --install-dir "${install_dir}" --bin-dir "${bin_dir}"

	# Clean up
	echo "Cleaning up..."
	rm -rf "${tmp_dir}" "${tarball}"

	echo "Azure CLI installation complete. Add ${bin_dir} to your PATH."
	# set +e
}

function _uninstall_azurecli() {
	:
}

function _activate_azurecli() {
	local -n __var=$1
	local -n __error=$2
	local install_dir="${HOME}/install/azurecli"
	local bin_dir="${install_dir}/bin"
	local completion_script="${install_dir}/az.completion"

	if [ -d "${bin_dir}" ]; then
		_bashy_pathutils_add_head PATH "${bin_dir}"
	fi

	if ! checkInPath "az" __var __error; then return; fi

	if [ -f "${completion_script}" ]; then
		# shellcheck source=/dev/null
		source "${completion_script}"
	fi
	__var=0
}

register_install _install_azurecli
register_interactive _activate_azurecli
