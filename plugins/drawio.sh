#!/bin/bash

function _install_drawio() {
    local install_dir="${HOME}/install/binaries"
    local temp_dir="/tmp/drawio_install"
    
    echo "Installing DrawIO to ${install_dir}/drawio..."
    
    # Check if install directory exists
    if [[ ! -d "${install_dir}" ]]; then
        echo "Error: Directory ${install_dir} does not exist"
        return 1
    fi
    
    # Create temporary directory
    mkdir -p "${temp_dir}"
    
    echo "Fetching latest DrawIO release information..."
    
    # Get latest release info from GitHub API
    local api_response
    if ! api_response=$(curl -s "https://api.github.com/repos/jgraph/drawio-desktop/releases/latest") || [[ -z "${api_response}" ]]; then
        echo "Error: Failed to fetch release information from GitHub API"
        rm -rf "${temp_dir}"
        return 1
    fi
    
    # Extract version and .deb download URL
    local version
    local download_url
    
    version=$(echo "${api_response}" | grep -o '"tag_name": *"[^"]*"' | cut -d'"' -f4)
    download_url=$(echo "${api_response}" | grep -o '"browser_download_url": *"[^"]*amd64[^"]*\.deb[^"]*"' | head -1 | cut -d'"' -f4)
    
    if [[ -z "${version}" ]] || [[ -z "${download_url}" ]]; then
        echo "Error: Could not parse version or .deb download URL from API response"
        rm -rf "${temp_dir}"
        return 1
    fi
    
    echo "Latest version: ${version}"
    echo "Download URL: ${download_url}"
    
    # Download the .deb package
    local filename
    filename=$(basename "${download_url}")
    local temp_file="${temp_dir}/${filename}"
    
    echo "Downloading ${filename}..."
    if ! curl -L -o "${temp_file}" "${download_url}" || [[ ! -f "${temp_file}" ]]; then
        echo "Error: Failed to download DrawIO .deb package"
        rm -rf "${temp_dir}"
        return 1
    fi
    
    # Install the .deb package
    echo "Installing .deb package..."
    if ! sudo dpkg -i "${temp_file}"; then
        echo "Error: Failed to install .deb package"
        rm -rf "${temp_dir}"
        return 1
    fi
    
    # Cleanup
    rm -rf "${temp_dir}"
    
    echo "✓ DrawIO ${version} successfully installed"
    echo "You can run it with: drawio"
    
    return 0
}

# Usage: install_drawio
