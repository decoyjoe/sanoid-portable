
# sanoid-portable Changelog

## 2.3.0-3

Fixed: SanoidPortable::Info module not found in APPerl @INC on macOS arm64.
Fixed: pp entry-point conflict with shared dispatch script; improved dependency scanning.
Fixed: Missing module dependencies for syncoid/findoid; hardened ARM CI test.
Fixed: ARM macOS build now includes syncoid and findoid tools properly.

## 2.3.0-2

Added: macOS arm64 (Apple Silicon) build, attached to releases as
`sanoid-portable-darwin-arm64`. The existing `sanoid-portable` asset is unchanged
and continues to target x86_64 Linux and FreeBSD via APPerl/Cosmopolitan.

## 2.3.0-1

Update to Sanoid [v2.3.0](https://github.com/jimsalterjrs/sanoid/releases/tag/v2.3.0).

## 2.2.0-2

Fixed: Executing sanoid-portable through symlinks caused failures launching subprocesses.

## 2.2.0-1

Initial sanoid-portable release.

Uses Sanoid [v2.2.0](https://github.com/jimsalterjrs/sanoid/releases/tag/v2.2.0).
