#!/usr/bin/env sh

set -eu

# Use the current directory by default
output_dir=$(pwd)

# Optionally pass in the output directory
# Usage: test.sh [output-directory]
if [ $# -gt 0 ] && [ -n "${1}" ]; then
  output_dir=$(realpath "${1}")
fi

sanoid_portable_path="${output_dir}/sanoid-portable"
if [ ! -f "${sanoid_portable_path}" ]; then
  echo "Error: sanoid-portable does not exist at \"$(dirname "${sanoid_portable_path}")\"."
  exit 1
fi

chmod +x "${output_dir}/sanoid-portable"
$sanoid_portable_path --help

expected_sanoid_version=$(jq -r '.Sanoid' versions.json)
expected_sanoid_portable_version="${expected_sanoid_version}-$(jq -r '.PackagingRevision' versions.json)"
actual_sanoid_portable_version=$($sanoid_portable_path --version)

if [ "${actual_sanoid_portable_version}" != "${expected_sanoid_portable_version}" ]; then
  echo "Error: Expected sanoid-portable version \"${expected_sanoid_portable_version}\" but got \"${actual_sanoid_portable_version}\"."
  exit 1
fi

for tool in sanoid syncoid findoid; do
  tool_path="${output_dir}/${tool}"

  # APPerl uses the invoking command name (argv[0]) to determine which internal script to run
  ln -sf sanoid-portable "${tool_path}"

  tool_version_output=$($tool_path --version | head -n 1)
  expected_version_output="/zip/bin/${tool} version ${expected_sanoid_version}"

  if [ "${tool_version_output}" != "${expected_version_output}" ]; then
    echo $tool_version_output
    echo "Error: Expected \"${tool} --version\" output to be \"${expected_version_output}\" but got \"${tool_version_output}\"."
    exit 1
  fi

  $tool_path --version
  $tool_path --help

  if [ $? -ne 0 ]; then
    echo "Error: Command \"${tool_path} --help\" failed with exit code $?"
    exit $?
  fi
done

ls -lah "${output_dir}"

echo ''

echo 'SHA-256 checksum:'
sha256sum $sanoid_portable_path
