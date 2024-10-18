#!/usr/bin/perl
use strict;
use warnings;
use JSON::PP;

my $usage = <<'USAGE';
This binary executes sanoid, syncoid, or findoid based on the name of the symbolic link invoked.

Create symbolic links to use the different tools:
    ln -s sanoid-portable sanoid
    ln -s sanoid-portable syncoid
    ln -s sanoid-portable findoid

Make sure to make sanoid-portable executable:
    chmod +x sanoid-portable

Then invoke the symlink:
    ./sanoid --help
    ./syncoid --help
    ./findoid --help

USAGE

open my $versions_json_file, '<', '../versions.json' or die "Can't open versions.json: $!";
my $versions_json = do { local $/; <$versions_json_file> };
close $versions_json_file;

my $versions = decode_json($versions_json);
my $sanoid_version = $versions->{'Sanoid'};
my $packaging_revision = $versions->{'PackagingRevision'};
my $apperl_version = $versions->{'APPerl'};
my $sanoid_portable_version = "$sanoid_version-$packaging_revision";

# Print versions
print "sanoid-portable: $sanoid_portable_version\n";
print "Sanoid: $sanoid_version\n";
print "Perl: $^V\n";  # Built-in variable for Perl version
print "APPerl: $apperl_version\n";

# Print usage information
print "\n$usage";
