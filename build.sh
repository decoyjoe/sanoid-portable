#!/bin/bash

set -euo pipefail

SANOID_VERSION=$(jq -r '.Sanoid' versions.json)
PACKAGING_REVISION=$(jq -r '.PackagingRevision' versions.json)
APPERL_VERSION=$(jq -r '.APPerl' versions.json)
SANOID_PORTABLE_VERSION="${SANOID_VERSION}-${PACKAGING_REVISION}"

echo "Building sanoid-portable version ${SANOID_PORTABLE_VERSION}, based on Sanoid version ${SANOID_VERSION} and APPerl version ${APPERL_VERSION}"

repo_root="$(realpath "$(dirname "$0")")"

# Cleanup previous artifacts if they exist
if [ -d build ]; then
  echo 'Cleaning up previous build...'
  rm -rf build
fi

mkdir build
pushd build > /dev/null

echo 'Downloading necessary modules...'

# Perl build dependency
# https://metacpan.org/dist/Module-Build
wget https://cpan.metacpan.org/authors/id/L/LE/LEONT/Module-Build-0.4234.tar.gz

# Sanoid dependency
# https://metacpan.org/dist/Config-IniFiles
wget https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/Config-IniFiles-3.000003.tar.gz

# Sanoid dependency
## https://metacpan.org/dist/Capture-Tiny
wget https://cpan.metacpan.org/authors/id/D/DA/DAGOLDEN/Capture-Tiny-0.48.tar.gz

echo 'Cloning sanoid repository...'
rm -rf sanoid_source
git clone https://github.com/jimsalterjrs/sanoid.git sanoid_source
echo ''

echo "Checking out Sanoid version \"${SANOID_VERSION}\""
pushd sanoid_source > /dev/null
git -c advice.detachedHead=false checkout "v${SANOID_VERSION}"
git log -1
popd > /dev/null
echo ''

echo 'Downloading APPerl (Actually Portable Perl)...'
wget -O perl.com "https://github.com/G4Vi/Perl-Dist-APPerl/releases/download/v${APPERL_VERSION}/perl.com"
chmod u+x perl.com

echo 'APPerl (perl.com) SHA-256 checksum:'
sha256sum perl.com
echo ''

# Bootstrap; use APPerl to build a custom APPerl.
ln -s perl.com apperlm

cp "${repo_root}/apperl-project.json" .
cp "${repo_root}/sanoid-portable.pl" .
cp "${repo_root}/versions.json" .

echo 'Installing build dependencies...'
./apperlm install-build-deps

echo 'Checking out the APPerl sanoid-portable build...'
./apperlm checkout sanoid-portable

echo 'Configuring build environment...'
./apperlm configure

echo 'Building sanoid-portable...'
./apperlm build

echo ''
echo 'Build complete.'
echo ''

stat sanoid-portable
echo ''

./sanoid-portable

# APPerl uses the invoking command name (argv[0]) to determine which internal script to run
ln -s sanoid-portable sanoid
ln -s sanoid-portable syncoid
ln -s sanoid-portable findoid

./sanoid --version
echo ''

echo 'Testing execution of sanoid...'
./sanoid --help
echo ''

echo 'Testing execution of syncoid...'
./syncoid --help
echo ''

echo 'Testing execution of findoid...'
./findoid --help
echo ''

echo 'SHA-256 checksum:'
sha256sum sanoid-portable

popd > /dev/null
