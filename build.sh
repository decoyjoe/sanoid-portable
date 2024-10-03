#!/bin/bash

set -euo pipefail

# Portable self-contained Perl
# https://github.com/G4Vi/Perl-Dist-APPerl/releases
APPERL_VERSION=0.6.1

# Sanoid
# https://github.com/jimsalterjrs/sanoid/releases
SANOID_VERSION=2.2.0

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

echo 'Installing build dependencies...'
./apperlm install-build-deps

echo 'Checking out the APPerl sanoid-portable build...'
./apperlm checkout sanoid-portable

echo 'Configuring build environment...'
./apperlm configure

echo 'Building sanoid-portable...'
./apperlm build

stat sanoid

echo ''
echo 'Build complete.'
echo 'Executing sanoid binary...'
echo ''

./sanoid -h
./sanoid --version

echo 'SHA-256 checksum:'
sha256sum sanoid

popd > /dev/null
