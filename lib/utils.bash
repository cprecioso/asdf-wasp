#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/wasp-lang/wasp"
TOOL_NAME="wasp"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	list_github_tags
}

download_specific_release() {
	local version platform arch filename
	version="$1"
	platform="$2"
	arch="$3"
	filename="$4"

	local asset_name="wasp-${platform}-${arch}.tar.gz"
	local url="$GH_REPO/releases/download/v${version}/$asset_name"

	echo "* Trying download for $TOOL_NAME release $version ($platform, $arch)..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || { echo "** Could not download $url." && false; }
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	# Detect platform
	case "$(uname -s)" in
	Darwin*) platform=("macos") ;;
	Linux*) platform=("linux-static" "linux") ;;
	*)
		echo "Unsupported platform" >&2
		exit 1
		;;
	esac

	case "$(uname -m)" in
	x86_64) arch=("x86_64" "universal") ;;
	arm64) arch=("aarch64" "universal" "x86_64") ;;
	*)
		echo "Unsupported architecture" >&2
		exit 1
		;;
	esac

	for p in "${platform[@]}"; do
		for a in "${arch[@]}"; do
			download_specific_release "$version" "$p" "$a" "$filename" || continue
			echo "* Downloaded wasp release $version for platform $p and architecture $a."
			return
		done
	done

	fail "Failed to download $TOOL_NAME release $version for platform $(uname -s) and architecture $(uname -m)."
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		mkdir -p "$install_path/bin"

		cp "$ASDF_DOWNLOAD_PATH/wasp-bin" "$install_path/bin/wasp"
		chmod +x "$install_path/bin/wasp"

		cp -r "$ASDF_DOWNLOAD_PATH/data" "$install_path/data"

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
