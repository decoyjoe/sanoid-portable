#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;
use JSON::PP;
use PAR;
use SanoidPortable::Info qw(print_info);

my $tool = basename($0);

if ($tool eq 'sanoid' || $tool eq 'syncoid' || $tool eq 'findoid') {
    my $code = PAR::read_file("bin/$tool")
        or die "Cannot read bundled script for '$tool'\n";
    eval $code;  ## no critic
    die $@ if $@;
    exit 0;
}

# Invoked directly as sanoid-portable — show help/version.
my $json = PAR::read_file('versions.json')
    or die "Cannot read bundled versions.json\n";
my $versions = decode_json($json);
my $sanoid_version          = $versions->{Sanoid};
my $packaging_revision      = $versions->{PackagingRevision};
my $sanoid_portable_version = "$sanoid_version-$packaging_revision";

print_info(
    sanoid_portable_version => $sanoid_portable_version,
    sanoid_version          => $sanoid_version,
);
