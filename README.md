
# sanoid-portable

Run [Sanoid](https://github.com/jimsalterjrs/sanoid) without installing any dependencies.

## Summary

*sanoid-portable* is a self-contained,  portable build of the [Sanoid](https://github.com/jimsalterjrs/sanoid) ZFS
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

Create symbolic links for each tool you plan to use (sanoid-portable uses the invoking command name (`argv[0]`) to
determine its behavior):

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

### Compatibility Notes

#### ZSH / fish

If you're using the ZSH or fish shells and you get an error such as `zsh: exec format error: sanoid-portable`, then you
need to update your shell. This issue is patched in [ZSH
5.9+](https://github.com/zsh-users/zsh/commit/326d9c203b3980c0f841bc62b06e37134c6e51ea) and [fish
3.3.0+](https://github.com/fish-shell/fish-shell/commit/0048730a67a5e70cafce1fb725a4b28001d924ac).

If you can't update your shell, then you ***must*** run sanoid-portable from a Thompson Shell-compatible shell such as
`bash`.

#### Ubuntu

On Ubuntu you may get an error such as `run-detectors: unable to find an interpreter` or `File does not contain a valid
CIL image.` This is because Ubuntu's built-in "MZ" binfmt interpreter "helpfully" tries to run the binary with Wine.

You have two options to fix this:

- [***Assimilate***](https://github.com/jart/cosmopolitan/blob/3.9.7/tool/cosmocc/README.md#installation) the
  sanoid-portable binary to transform it into a native ELF binary at the expense of making it no longer portable, i.e.
  it will henceforth only run on Linux platforms:

    ```console
    sh ./sanoid-portable --assimilate # Transforms the binary into ELF
    ./sanoid-portable --help
    ```

- OR

- Add a new binfmt entry that matches APE's ([Actually Portable Executable](https://justine.lol/ape.html))'s magic number to avoid execution by Ubuntu's built-in "MZ" binfmt interpreter:

    ```console
    sudo update-binfmts --install APE /bin/sh --magic MZqFpD
    ./sanoid-portable --help
    ```

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

## License

This project is licensed under the GPL v3.0 license - see the [LICENSE](LICENSE) file for details.
