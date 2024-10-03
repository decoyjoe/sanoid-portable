#!/usr/bin/perl

my $sanoid_portable_version = "1.0.0";

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

# Print version information
print "sanoid-portable: $sanoid_portable_version\n";
print "Perl: $^V\n";  # Built-in variable for Perl version

# Print usage information
print "\n$usage";
