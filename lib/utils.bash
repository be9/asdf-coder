#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/coder/coder"
TOOL_NAME="coder"
TOOL_TEST="coder --version"

os() {
	uname="$(uname)"
	case $uname in
	Linux) echo linux ;;
	Darwin) echo darwin ;;
	FreeBSD) echo freebsd ;;
	*) echo "$uname" ;;
	esac
}

arch() {
	uname_m=$(uname -m)
	case $uname_m in
	aarch64) echo arm64 ;;
	x86_64) echo amd64 ;;
	armv7l) echo armv7 ;;
	*) echo "$uname_m" ;;
	esac
}

OS=${OS:-$(os)}
ARCH=${ARCH:-$(arch)}
case $OS in
    darwin) STANDALONE_ARCHIVE_FORMAT=zip ;;
	*) STANDALONE_ARCHIVE_FORMAT=tar.gz ;;
esac

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if coder is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_all_versions() {
    curl -fsSL https://api.github.com/repos/coder/coder/releases |
        awk -F'"' '/"tag_name"/ {print $4}' |
        tr -d v
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	url="$GH_REPO/releases/download/v$version/coder_${version}_${OS}_${ARCH}.$STANDALONE_ARCHIVE_FORMAT"
	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}

has_standalone() {
	case $ARCH in
	amd64) return 0 ;;
	arm64) return 0 ;;
	armv7)
		[ "$(distro)" != darwin ]
		return
		;;
	*) return 1 ;;
	esac
}
