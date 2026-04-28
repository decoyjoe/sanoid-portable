
# sanoid-portable

Run [Sanoid, Syncoid, and Findoid](https://github.com/jimsalterjrs/sanoid) without installing any dependencies.

## Summary

*sanoid-portable* is a self-contained, portable build of the [Sanoid](https://github.com/jimsalterjrs/sanoid) ZFS
snapshot management tool. It bundles the Perl runtime, all required Perl dependencies, and the
Sanoid/Syncoid/Findoid scripts themselves, so you can run Sanoid without installing additional Perl
dependencies or configuring the system's Perl environment.

This is useful if you'd like to use Sanoid on an appliance-like storage system, such as TrueNAS, where standard package
installations are restricted or non-ideal.

## Build flavors

Two flavors are produced, each from a different toolchain. Pick the one that matches your platform:

| Flavor                          | Asset name                       | Target platforms                       | Toolchain                                                            | Build script    |
| ------------------------------- | -------------------------------- | -------------------------------------- | -------------------------------------------------------------------- | --------------- |
| **APE** (Actually Portable Executable) | `sanoid-portable`                | x86_64 Linux, FreeBSD                  | [APPerl](https://computoid.com/APPerl/) / [Cosmopolitan](https://github.com/jart/cosmopolitan) | `build-ape.sh`  |
| **macOS arm64**                 | `sanoid-portable-darwin-arm64`   | macOS on Apple Silicon (darwin-arm64)  | Homebrew perl + [PAR::Packer](https://metacpan.org/pod/PAR::Packer)  | `build-arm.sh`  |

The APE binary is a single x86_64 executable that runs unmodified on Linux and FreeBSD via Cosmopolitan; it is the
flavor described under "Installation" below. The macOS arm64 binary is a self-extracting darwin-arm64 executable and
is **not** cross-platform — it only runs on Apple Silicon macOS.

The following files in this repo are APE-specific (they configure the APPerl/Cosmopolitan build):

- `build-ape.sh`, `init-ape-build.sh`
- `apperl-project.json`, `sanoid-portable-ape.pl`
- `ape-patches/` (sanoid script patches required to bundle inside an APPerl zip)
- `test-smoke.sh`, `test-integration.sh` (tests assert the APE-specific `/zip/bin/...` paths)

The macOS arm64 build is fully described by `build-arm.sh`, `sanoid-portable-arm.pl`, and the `build-arm` job in
`.github/workflows/build.yml`.

`versions.json` and `CHANGELOG.md` are shared.

## Installation

### Linux / FreeBSD (x86_64)

The following steps download the APE binary, make it executable, transform
([*assimilate*](https://github.com/jart/cosmopolitan/blob/3.9.7/tool/cosmocc/README.md#installation)) it into a native
binary for your system, and set up symbolic links for each tool (`sanoid`, `syncoid`, `findoid`):

```console
wget https://github.com/ssalonen/sanoid-portable/releases/latest/download/sanoid-portable
chmod +x sanoid-portable
sh ./sanoid-portable --assimilate # Transforms portable into a native binary
ln -s sanoid-portable sanoid
ln -s sanoid-portable syncoid
ln -s sanoid-portable findoid
```

### macOS (Apple Silicon)

```console
wget https://github.com/ssalonen/sanoid-portable/releases/latest/download/sanoid-portable-darwin-arm64 -O sanoid-portable
chmod +x sanoid-portable
ln -s sanoid-portable sanoid
ln -s sanoid-portable syncoid
ln -s sanoid-portable findoid
```

The macOS build is a PAR::Packer self-extracting binary; `--assimilate` does not apply.

## Usage

Invoke the symbolic link:

```console
./sanoid --help
./syncoid --help
./findoid --help
```

Now you just need to configure Sanoid to do what you need it to do. Refer to the [Sanoid
documentation](https://github.com/jimsalterjrs/sanoid) for configuration instructions.

### Compatibility Notes

#### Windows Subsystem for Linux (WSL)

In WSL you need to disable the [`WSLInterop`](https://learn.microsoft.com/en-us/windows/wsl/filesystems#disable-interoperability) binfmt interpreter that's used to launch Windows binaries from Linux:

```console
sudo sh -c 'echo 0 > $(ls /proc/sys/fs/binfmt_misc/WSLInterop*)'
```

## Developing

### Building the APE flavor (Linux/FreeBSD)

Run the initialization script to prepare your environment to build the APE executable on a Debian-based
system:

```console
./init-ape-build.sh
```

Build the executable:

```console
./build-ape.sh
```

This script downloads and configures APPerl, downloads the necessary Perl modules, and builds the portable Sanoid
binary at `output/sanoid-portable`.

### Building the macOS arm64 flavor

On a macOS arm64 host with Homebrew installed:

```console
brew install perl cpanminus jq
export PATH="$(brew --prefix perl)/bin:$PATH"
cpanm --local-lib="$HOME/perl5" --notest Config::IniFiles Capture::Tiny PAR::Packer
export PATH="$HOME/perl5/bin:$PATH"
export PERL5LIB="$HOME/perl5/lib/perl5"

./build-arm.sh
```

The output lands at `output/sanoid-portable`.

## Credits

We stand on the shoulders of giants. Thanks to:

- [jimsalterjrs/sanoid](https://github.com/jimsalterjrs/sanoid) for the excellent ZFS snapshot management tool.
- [G4Vi/Perl-Dist-APPerl](https://github.com/G4Vi/Perl-Dist-APPerl) for the tooling to create single-binary portable
  Perl distributions.
- [jart/cosmopolitan](https://github.com/jart/cosmopolitan) for making truly cross-platform portable binaries possible.
- [PAR::Packer](https://metacpan.org/pod/PAR::Packer) for packaging the macOS arm64 build.

## Releasing a new version

The release process is fully automated via GitHub Actions. To release a new version:

1. In [versions.json](./versions.json), increment the `PackagingRevision` number, or if updating the `Sanoid` version
   reset `PackagingRevision` back to `1`.
1. Update [CHANGELOG.md](./CHANGELOG.md) with release notes for the new version. The release workflow asserts the
   CHANGELOG contains a heading matching the release tag.
1. Merge the changes to the mainline branch.
1. Publish a GitHub release with a tag matching the new version (e.g. `2.3.0-1`):

   - **Web UI:** Releases → *Draft a new release* → choose/create the tag → fill in notes → *Publish release*.
   - **CLI:** `gh release create 2.3.0-1 --title 2.3.0-1 --notes-file release-notes.md`

Publishing the release fires the `release: published` event, which triggers `.github/workflows/release.yml`. That
workflow builds both flavors and attaches them to the release as two assets:

- `sanoid-portable` — APE build (x86_64 Linux/FreeBSD)
- `sanoid-portable-darwin-arm64` — macOS Apple Silicon build

Both assets get [build provenance attestations](https://docs.github.com/en/actions/security-guides/using-artifact-attestations-to-establish-provenance-for-builds).

## License

This project is licensed under the GPL v3.0 license - see the [LICENSE](LICENSE) file for details.
