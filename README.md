
# sanoid-portable

Run [Sanoid](https://github.com/jimsalterjrs/sanoid) without installing any dependencies.

## Summary

sanoid-portable is a self-contained,  portable build of the [Sanoid](https://github.com/jimsalterjrs/sanoid) ZFS
snapshot management tool. Built using [APPerl (Actually Portable Perl)](https://computoid.com/APPerl/), this
self-contained, portable binary encompasses the Perl runtime, all required Perl dependencies, and the Sanoid script
itself. This enables you to run Sanoid on any Linux or FreeBSD system without needing to install additional Perl
dependencies or configure the system's Perl environment.

This is useful if you'd like to use Sanoid on an appliance-like storage system, such as TrueNAS, where standard package
installations are restricted or non-ideal.

## Installation

Download the latest version of sanoid-portable from the GitHub releases and make it executable:

```console
wget https://github.com/decoyjoe/sanoid-portable/releases/latest/download/sanoid-portable
chmod +x sanoid-portable
```

Since sanoid-portable uses the invoking command name (`argv[0]`) to determine its behavior, create symbolic links for each
tool you plan to use:

```console
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

Refer to the [Sanoid documentation](https://github.com/jimsalterjrs/sanoid) for configuration instructions.

## Developing

Run the initialization script to prepare your environment to build the sanoid-portable executable on a Debian-based system:

```console
./init.sh
```

Build the executable:

```console
./build.sh
```

This script will download and configure APPerl, download necessary Perl modules, and build the portable Sanoid binary.

The executable gets built to `build/sanoid-portable`.

## License

This project is licensed under the GPL v3.0 license - see the [LICENSE](LICENSE) file for details.
