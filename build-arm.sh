#!/usr/bin/env bash
#
# Build the macOS arm64 flavor of sanoid-portable using PAR::Packer (pp).
# The output is a self-extracting darwin-arm64 binary that bundles a perl
# interpreter, a dispatcher, and all three sanoid scripts (sanoid, syncoid,
# findoid) -- it is NOT cross-platform.
# Run this on a macOS arm64 host with Homebrew perl + PAR::Packer already
# installed and ~/perl5/bin first on PATH (see .github/workflows/build.yml,
# job build-arm). For the portable Linux/FreeBSD flavor, see build-ape.sh.

set -euo pipefail

repo_root="$(cd "$(dirname "$0")" && pwd)"

SANOID_VERSION=$(jq -r '.Sanoid' "${repo_root}/versions.json")

PP_PATH="$(command -v pp || true)"
if [ -z "${PP_PATH}" ]; then
  echo "Error: pp (PAR::Packer) not found on PATH." >&2
  exit 1
fi

# Refuse to use a stray /usr/bin/pp that the runner image may ship --
# its shebang points at /usr/bin/perl which won't have our modules.
case "${PP_PATH}" in
  "${HOME}/perl5/bin/pp") ;;
  *)
    echo "Error: pp resolved to ${PP_PATH}, expected ${HOME}/perl5/bin/pp." >&2
    exit 1
    ;;
esac

mkdir -p "${repo_root}/output"
pushd "${repo_root}/output" > /dev/null

if [ -d sanoid_source ]; then
  rm -rf sanoid_source
fi

echo "Cloning sanoid version v${SANOID_VERSION}..."
git clone https://github.com/jimsalterjrs/sanoid.git sanoid_source
pushd sanoid_source > /dev/null
git -c advice.detachedHead=false checkout "v${SANOID_VERSION}"
git log -1
popd > /dev/null

echo "Building sanoid-portable (darwin-arm64) with PAR::Packer..."
cd sanoid_source

# pp only statically analyses the main script for deps, not scripts bundled
# via -a. Listing them as additional input files also does not work: pp's
# multi-script bootstrap selects the script to run by matching the binary
# name, which would fail since our dispatcher is sanoid-portable-arm.pl
# while the binary is sanoid-portable. Instead, scan the tool scripts for
# capitalised 'use Module' lines and pass them as explicit -M flags.
# Lowercase 'use' lines are Perl pragmas and are skipped.
module_args=()
while read -r mod; do
  module_args+=(-M "$mod")
done < <(grep -h '^use [A-Z]' sanoid syncoid findoid \
           | sed 's/^use \([A-Za-z][A-Za-z0-9:]*\).*/\1/' \
           | sort -u)

perl "${PP_PATH}" \
  -I "${repo_root}" \
  "${module_args[@]}" \
  -a "sanoid;bin/sanoid" \
  -a "syncoid;bin/syncoid" \
  -a "findoid;bin/findoid" \
  -a "${repo_root}/versions.json;versions.json" \
  -o ../sanoid-portable \
  "${repo_root}/sanoid-portable-arm.pl"

popd > /dev/null

echo ""
echo "Build complete: ${repo_root}/output/sanoid-portable"
