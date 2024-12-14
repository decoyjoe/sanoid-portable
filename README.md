
# sanoid-portable

Run [Sanoid, Syncoid, and Findoid](https://github.com/jimsalterjrs/sanoid) without installing any dependencies.

## Summary

*sanoid-portable* is a self-contained,  portable build of the [Sanoid](https://github.com/jimsalterjrs/sanoid) ZFS
snapshot management tool. Built using [APPerl (Actually Portable Perl)](https://computoid.com/APPerl/), this
self-contained, portable binary encompasses the Perl runtime, all required Perl dependencies, and the
Sanoid/Syncoid/Findoid scripts themselves. This enables you to run Sanoid on any Linux or FreeBSD system without needing
to install additional Perl
dependencies or configure the system's Perl environment.

This is useful if you'd like to use Sanoid on an appliance-like storage system, such as TrueNAS, where standard package
installations are restricted or non-ideal.

## Installation

- Download the latest version of sanoid-portable from the GitHub releases and make it executable.
- [***Assimilate***](https://github.com/jart/cosmopolitan/blob/3.9.7/tool/cosmocc/README.md#installation) the
  sanoid-portable binary to transform it into a native binary for the current system.
- Create symbolic links for each tool you plan to use (sanoid-portable uses the invoking command name (`argv[0]`) to
determine which tool it runs.

```console
wget https://github.com/decoyjoe/sanoid-portable/releases/latest/download/sanoid-portable
chmod +x sanoid-portable
sh ./sanoid-portable --assimilate # Transforms portable into a native binary
ln -s sanoid-portable sanoid
ln -s sanoid-portable syncoid
ln -s sanoid-portable findoid
```

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

Run the initialization script to prepare your environment to build the sanoid-portable executable on a Debian-based
system:

```console
./init.sh
```

Build the executable:

```console
./build.sh
```

This script will download and configure APPerl, download necessary Perl modules, and build the portable Sanoid binary.

The executable gets built to `output/sanoid-portable`.

## Credits

We stand on the shoulders of giants. Thanks to:

- [jimsalterjrs/sanoid](https://github.com/jimsalterjrs/sanoid) for the excellent ZFS snapshot management tool.
- [G4Vi/Perl-Dist-APPerl](https://github.com/G4Vi/Perl-Dist-APPerl) for the tooling to create single-binary portable
  Perl distributions.
- [jart/cosmopolitan](https://github.com/jart/cosmopolitan) for making truly cross-platform portable binaries possible.

## License

This project is licensed under the GPL v3.0 license - see the [LICENSE](LICENSE) file for details.
