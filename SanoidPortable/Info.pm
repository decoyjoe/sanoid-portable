package SanoidPortable::Info;
use strict;
use warnings;
use Getopt::Long;
use Exporter 'import';

our @EXPORT_OK = qw(print_info);

my $usage = <<'EOF';
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

Options:
    -V, --version   Print version information and exit
    -h, --help      Print this help message and exit

EOF

# Prints help/version info and exits when --version or --help is given.
# Args (hash):
#   sanoid_portable_version - e.g. "2.3.0-2"
#   sanoid_version          - e.g. "2.3.0"
#   extra_versions          - optional extra lines appended after "Perl: ...",
#                             e.g. "APPerl: 0.1.0" (no trailing newline needed)
sub print_info {
    my (%args) = @_;
    my $sanoid_portable_version = $args{sanoid_portable_version};
    my $sanoid_version          = $args{sanoid_version};
    my $extra_versions          = $args{extra_versions} // '';

    my ($print_version_only, $print_help);
    GetOptions(
        'V|version' => \$print_version_only,
        'h|help'    => \$print_help,
    );

    if ($print_version_only) {
        print "$sanoid_portable_version\n";
        exit 0;
    }

    my $versions = "sanoid-portable: $sanoid_portable_version\nsanoid: $sanoid_version\nPerl: $^V\n";
    $versions   .= "$extra_versions\n" if $extra_versions;

    print $usage;
    print "$versions\n";
}

1;
