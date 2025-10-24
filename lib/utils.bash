#!/usr/bin/env bash

set -eo pipefail

GH_REPO="https://github.com/thought-machine/please"

fail() {
  echo -e "\e[31mFail:\e[m $*"
  exit 1
}

curl_opt=("-fSL")

if test -n "$GITHUB_API_TOKEN"; then
  curl_opt+=("-H" "'Authorization: token $GITHUB_API_TOKEN'")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" | grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//'
}

list_all_versions() {
  list_github_tags
}

platform() {
  local architecture
  local platform

  case "$(uname -m)" in
    x86_64 | x86-64 | x64 | amd64) architecture="amd64" ;;
    arm64) architecture="arm64" ;;
    *) fail "Unsupported architecture" ;;
  esac

  case "$(uname -s)" in
    Darwin*) platform="darwin_${architecture}" ;;
    Linux*) platform="linux_${architecture}" ;;
    *) fail "Unsupported platform" ;;
  esac

  echo "$platform"
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  url="$GH_REPO/releases/download/v${version}/please_${version}_$(platform).tar.xz"

  echo "* Downloading please release $version..."
  curl "${curl_opt[@]}" --output "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-please supports release installs only"
  fi

  (
    local release_file="$install_path/please-$version.tar.xz"
    mkdir -p "$install_path/bin"
    download_release "$version" "$release_file"
    tar -xJpf "$release_file" -C "$install_path/bin" --strip-components=1 || fail "Could not extract $release_file"
    rm "$release_file"
    (
      cd "$install_path/bin"
      ln -s please plz
    )
    echo "please $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing please $version."
  )
}
