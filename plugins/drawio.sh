function _install_drawio() {
  local install_dir="${HOME}/install/binaries"

  echo "Installing DrawIO to ${install_dir}/drawio..."

  # Check if install directory exists
  if [[ ! -d "${install_dir}" ]]
  then
    echo "Error: Directory ${install_dir} does not exist"
    return 1
  fi

  echo "Fetching latest DrawIO release information..."

  # Get latest release info from GitHub API
  local api_response
  if ! api_response=$(curl -s "https://api.github.com/repos/jgraph/drawio-desktop/releases/latest") || [[ -z "${api_response}" ]]; then
    echo "Error: Failed to fetch release information from GitHub API"
    return 1
  fi

  # Extract version and .deb download URL
  local version
  local download_url

  version=$(echo "${api_response}" | grep -o '"tag_name": *"[^"]*"' | cut -d'"' -f4)
  download_url=$(echo "${api_response}" | grep -o '"browser_download_url": *"[^"]*amd64[^"]*\.deb[^"]*"' | head -1 | cut -d'"' -f4)

  if [[ -z "${version}" ]] || [[ -z "${download_url}" ]]
  then
    echo "Error: Could not parse version or .deb download URL from API response"
    return 1
  fi

  echo "Latest version: ${version}"
  echo "Download URL: ${download_url}"

  # Compare with installed version
  local latest_version="${version#v}"
  local installed_version
  installed_version=$(dpkg-query -W -f='${Version}' drawio 2>/dev/null || true)
  if bashy_install_check "drawio" "${installed_version}" "${latest_version}"
  then
    return 0
  fi

  # Download the .deb package
  local temp_file
  if ! bashy_download "${download_url}" temp_file; then
    echo "Error: Failed to download DrawIO .deb package"
    return 1
  fi

  # Install the .deb package
  echo "Installing .deb package..."
  if ! sudo dpkg -i "${temp_file}"
  then
    echo "Error: Failed to install .deb package"
    return 1
  fi

  echo "✓ DrawIO ${version} successfully installed"
  echo "You can run it with: drawio"
  return 0
}

function _activate_drawio() {
  local -n __var=$1
  local -n __error=$2
  __var=0
}

register_interactive _activate_drawio
