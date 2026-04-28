#!/usr/bin/perl
use strict;
use warnings;
use lib '/zip/lib';
use FindBin;
use JSON::PP;
use SanoidPortable::Info qw(print_info);

open my $fh, '<', "$FindBin::Bin/../lib/versions.json" or die "Can't open versions.json: $!";
my $versions = decode_json(do { local $/; <$fh> });
close $fh;

my $sanoid_version          = $versions->{'Sanoid'};
my $packaging_revision      = $versions->{'PackagingRevision'};
my $apperl_version          = $versions->{'APPerl'};
my $sanoid_portable_version = "$sanoid_version-$packaging_revision";

print_info(
    sanoid_portable_version => $sanoid_portable_version,
    sanoid_version          => $sanoid_version,
    extra_versions          => "APPerl: $apperl_version",
);
